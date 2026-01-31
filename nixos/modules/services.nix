{pkgs, ...}: let
  trashDownloadsScript = pkgs.writeShellScript "trash-downloads.sh" ''
    #!${pkgs.bash}/bin/bash
    set -euo pipefail

    TARGET="/home/nick/Downloads"

    # Bail out early if the directory does not exist or is empty.
    if [[ ! -d "$TARGET" ]] || [[ -z "$(ls -A "$TARGET" 2>/dev/null)" ]]; then
      exit 0
    fi

    # Loop over *all* entries (files, directories, symlinks, …) and trash them.
    # Using `shopt -s nullglob` makes the loop safe when the directory is empty.
    shopt -s nullglob dotglob
    for entry in "$TARGET"/*; do
      # Skip if the entry vanished between the glob and now.
      [[ -e "$entry" || -L "$entry" ]] || continue
      ${pkgs.glib}/bin/gio trash "$entry" || echo "Warning: Failed to trash $entry" >&2
    done
  '';
in {
  security.polkit.enable = true;
  services.dbus.implementation = "broker";

  services.kanata = {
    enable = true;

    package = pkgs.kanata-with-cmd;

    keyboards."logi" = {
      extraDefCfg = ''
        process-unmapped-keys yes
        danger-enable-cmd yes
      '';

      # Note: This requires the compose key to be set to rctrl (right control) in Gnome settings
      config = ''
        (defsrc)

        (deflayermap (base-layer) 
          lalt @umlauts
          ralt @umlauts
        )

        (deflayermap (german)
          u @ue
          o @oe
          a @ae
          s @sz
        )

        (defalias
          umlauts (layer-while-held german)
          Ae (macro rctrl S-' S-a)
          Ue (macro rctrl S-' S-u)
          Oe (macro rctrl S-' S-o)
          ae (macro rctrl S-' a)
          ue (macro rctrl S-' u)
          oe (macro rctrl S-' o)
          _ae (fork @ae @Ae (lsft rsft))
          _ue (fork @ue @Ue (lsft rsft))
          _oe (fork @oe @Oe (lsft rsft))
          sz (macro rctrl s s)
        )
      '';
    };
  };

  services.fwupd.enable = true;

  # Needed for Gnome
  services.xserver = {
    # Required for DE to launch.
    enable = true;

    xkb.layout = "de";

    # Exclude default X11 packages I don't want.
    excludePackages = with pkgs; [xterm];
  };

  # DisplayLink daemon
  systemd.services.dlm.wantedBy = [ "multi-user.target" ];

  # For piper
  services.ratbagd.enable = true;

  services.desktopManager.gnome.enable = true;
  services.gnome.sushi.enable = true;

  services.displayManager = {
    gdm.enable = true;

    autoLogin = {
      enable = true;
      user = "nick";
    };
  };

  # Better OOM-Daemon 'cause fuck systemd-oom
  systemd.oomd.enable = false;
  services.earlyoom = {
    enable = true;
    enableNotifications = true;

    # Send SIGTERM when only 2% of RAM and (!!!) SWAP are free
    # Sends SIGKILL on 1%
    freeMemThreshold = 2;
    freeSwapThreshold = 2;

    extraArgs = [
      "-g"
      "--prefer"
      "(^|/)(java|chromium|librewolf|electron)$"
      "--ignore"
      "(^|/)(systemd)$" # TODO Add gnome stuff here
    ];
  };

  # Proxy systemd-bus notifications to libnotify
  services.systembus-notify.enable = true;

  # Nobody needs the default 4GB of logs...
  services.journald.extraConfig = ''
    SystemMaxUse=500M
  '';

  # User service - runs on login (recommended)
  systemd.user.services.trash-downloads-on-login = {
    enable = true;
    description = "Trash everything in /home/nick/Downloads on login";
    wantedBy = ["default.target"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${trashDownloadsScript}";
    };
  };
}
