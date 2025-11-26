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

     keyboards = {
      "logi".config = ''
        (defcustomkeys
          ü    186
          ö    192
          ß    219
          ä    222
          mute 113
        )
        
        (defsrc
                                                                           mute
          grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
          caps a    s    d    f    g    h    j    k    l    ;    '    ret
          lsft z    x    c    v    b    n    m    ,    .    /    rsft
          lctl lmet lalt           spc            ralt rmet rctl
        )

        (deflayermap (base-layer) 
          u ü
          o ö
          a ä
          s ß
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

  services.desktopManager.gnome.enable = true;

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

  # https://discourse.nixos.org/t/zfs-rollback-not-working-using-boot-initrd-systemd/37195/2
  boot.initrd.systemd.services.rollback = {
    description = "roolback rootfs on boot";
    wantedBy = ["initrd.target"];

    # This service is called zfs-import-<poolname>.service
    # Look up your poolname in disko.nix next time before debugging for 3 hours...
    after = ["zfs-import-zroot.service"];

    before = ["sysroot.mount"];

    path = with pkgs; [zfs];

    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      zfs rollback -r zroot/root@blank
    '';
  };
}
