{
  writeShellScriptBin,
  bash,
  wireplumber,
  gnugrep,
  gnused,
  gawk,
  coreutils,
}:
writeShellScriptBin "mic-default-policy" ''
  #!${bash}/bin/bash
  set -euo pipefail

  # Keep this regex aligned with the external mic source name from:
  #   wpctl status -n / wpctl inspect <ID>
  ALLOWED_SOURCE_REGEX='(Snowball|Blue)'
  WPCTL='${wireplumber}/bin/wpctl'
  GREP='${gnugrep}/bin/grep'
  SED='${gnused}/bin/sed'
  AWK='${gawk}/bin/awk'

  get_source_ids() {
    # Limit parsing to the Sources section to avoid scanning unrelated object IDs.
    "$WPCTL" status -n \
      | "$SED" -n '/Sources:/,/Filters:/ s/^[[:space:]]*[*[:space:]]*\([0-9][0-9]*\)\..*/\1/p' \
      | "$AWK" '!seen[$1]++'
  }

  apply_policy_once() {
    local found=0

    while IFS= read -r object_id; do
      [[ -n "''${object_id:-}" ]] || continue
      found=1

      inspect_out=$("$WPCTL" inspect "$object_id" 2>/dev/null || true)
      echo "$inspect_out" | "$GREP" -q 'media.class = "Audio/Source"' || continue

      source_name=$(echo "$inspect_out" | "$SED" -n 's/.*node.description = "\(.*\)".*/\1/p' | ${coreutils}/bin/head -n1)
      if [[ -z "''${source_name:-}" ]]; then
        source_name=$(echo "$inspect_out" | "$SED" -n 's/.*node.name = "\(.*\)".*/\1/p' | ${coreutils}/bin/head -n1)
      fi

      if echo "$source_name" | "$GREP" -Eiq "$ALLOWED_SOURCE_REGEX"; then
        "$WPCTL" set-mute "$object_id" 0 || true
      else
        "$WPCTL" set-volume "$object_id" 0 || true
        "$WPCTL" set-mute "$object_id" 1 || true
      fi
    done < <(get_source_ids)

    [[ "$found" -eq 1 ]]
  }

  # Wait for sources to appear (race at login is common with WirePlumber startup).
  ready=0
  for _ in $(seq 1 20); do
    if apply_policy_once; then
      ready=1
      break
    fi
    sleep 1
  done

  if [[ "$ready" -ne 1 ]]; then
    echo "mic-default-policy: no audio sources found within timeout" >&2
    exit 0
  fi

  # Re-apply for a short window to catch devices that appear right after login.
  for _ in $(seq 1 8); do
    sleep 2
    apply_policy_once || true
  done
''