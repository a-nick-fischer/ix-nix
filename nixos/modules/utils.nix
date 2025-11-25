{pkgs, ...}: {
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "game" ''
      #!/usr/bin/env bash
      set -euo pipefail

      if ! command -v gamemoderun >/dev/null; then
        echo "gamemoderun not found in PATH" >&2
        exit 1
      fi

      if ! command -v nvidia-offload >/dev/null; then
        echo "nvidia-offload not found in PATH" >&2
        exit 1
      fi

      if [[ $# -lt 1 ]]; then
        echo "Usage: $0 <executable> [args...]" >&2
        exit 1
      fi

      exec nvidia-offload gamemoderun "$@"
    '')
  ];
}
