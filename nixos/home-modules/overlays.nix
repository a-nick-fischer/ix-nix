{
  ...
}: {
  nixpkgs.overlays = [
    (final: prev:
    let 
      nvidiaOffloadWrap = { executable, desktop ? null }: prev.runCommand "nvidia-offload"
      {
        preferLocalBuild = true;
        allowSubstitutes = false;
        meta.priority = -1; # take precedence over non-accelarated versions
      }
      (
        ''
          command_path="$out/bin/$(basename ${executable})"
          mkdir -p $out/bin
          mkdir -p $out/share/applications
          cat <<'_EOF' >"$command_path"
          #! ${prev.bash}/bin/bash -e
          exec /run/current-system/sw/bin/nvidia-offload '${toString executable}' "$@"
          _EOF
          chmod 0755 "$command_path"
        '' + prev.lib.optionalString (desktop != null) ''
          substitute '${desktop}' "$out/share/applications/$(basename ${desktop})" \
            --replace-quiet '${executable}' "$command_path"
          cp -r "$(dirname ${desktop})/../icons" "$out/share/icons"
        ''
      );

      # Stolen from https://www.reddit.com/r/NixOS/comments/1b56jdx/simple_nix_function_for_wrapping_executables_with/
      firejailWrap = { executable, desktop ? null, profile ? null, extraArgs ? [ ] }: prev.runCommand "firejail-wrap"
      {
        preferLocalBuild = true;
        allowSubstitutes = false;
        meta.priority = -1; # take precedence over non-firejailed versions
      }
      (
        let
          firejailArgs = prev.lib.concatStringsSep " "  (
            extraArgs ++ (prev.lib.optional (profile != null) "--profile=${toString profile}")
          );
        in
        ''
          command_path="$out/bin/$(basename ${executable})"
          mkdir -p $out/bin
          mkdir -p $out/share/applications
          cat <<'_EOF' >"$command_path"
          #! ${prev.bash}/bin/bash -e
          exec '/run/wrappers/bin/firejail' ${firejailArgs} -- '${toString executable}' "$@"
          _EOF
          chmod 0755 "$command_path"
        '' + prev.lib.optionalString (desktop != null) ''
            substitute '${desktop}' "$out/share/applications/$(basename ${desktop})" \
              --replace-quiet '${executable}' "$command_path"
            cp -r "$(dirname ${desktop})/../icons" "$out/share/icons"
        ''
      );
    in
    {
      flameshot = prev.flameshot.override (old: {
        enableWlrSupport = true;
      });
      
      kitty = nvidiaOffloadWrap {
        executable = "${prev.kitty}/bin/kitty";
        desktop = "${prev.kitty}/share/applications/kitty.desktop";
      };

      hyprlock = nvidiaOffloadWrap {
        executable = "${prev.hyprlock}/bin/hyprlock";
      };

      librewolf = firejailWrap {
        executable = "${prev.librewolf}/bin/librewolf";
        desktop = "${prev.librewolf}/share/applications/librewolf.desktop";
        extraArgs = [ 
          "--dbus-user.talk=org.freedesktop.Notifications"
          "--dbus-user.talk=org.freedesktop.portal.*" 
        ];
      };

      tor-browser = firejailWrap {
        executable = "${prev.tor-browser}/bin/tor-browser";
        desktop = "${prev.tor-browser}/share/applications/torbrowser.desktop";
      };
    })
  ];
}