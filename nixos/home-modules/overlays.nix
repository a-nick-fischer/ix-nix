{
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev:
    let 
      # Based on https://www.reddit.com/r/NixOS/comments/1b56jdx/simple_nix_function_for_wrapping_executables_with/
      nvidiaOffloadWrap = { executable, desktop ? null }: prev.runCommand "nvidia-offload"
      {
        preferLocalBuild = true;
        allowSubstitutes = false;
        meta.priority = -1; # take precedence over non-firejailed versions
      }
      (
        ''
          command_path="$out/bin/$(basename ${executable})"
          mkdir -p $out/bin
          mkdir -p $out/share/applications
          cat <<'_EOF' >"$command_path"
          #! ${prev.bash}/bin/bash -e
          exec /run/current-system/sw/bin/nvidia-offload ${toString executable} "$@"
          _EOF
          chmod 0755 "$command_path"
        '' + prev.lib.optionalString (desktop != null) ''
          substitute ${desktop} $out/share/applications/$(basename ${desktop}) \
            --replace ${executable} "$command_path"
        ''
      );
    in
    {
      ags = prev.ags.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ pkgs.libdbusmenu-gtk3 pkgs.libnotify ];
      });

      flameshot = prev.flameshot.override (old: {
        enableWlrSupport = true;
      });
      
      kitty = nvidiaOffloadWrap {
        executable = "${prev.kitty}/bin/kitty";
        desktop = "${prev.kitty}/share/applications/kitty.desktop"; # TODO There's another one..
      };

      hyprlock = nvidiaOffloadWrap {
        executable = "${prev.hyprlock}/bin/hyprlock";
      };
    })
  ];
}