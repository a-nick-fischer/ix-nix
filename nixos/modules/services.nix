{
  pkgs,
  ...
}: {
  security.pam.services.hyprlock = {};
  security.polkit.enable = true;
  services.dbus.implementation = "broker";

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
      "--prefer '(^|/)(java|chromium|librewolf|electron)$'"
      "--avoid '(^|/)(ags)$'"
      "--ignore '(^|/)(Hyprland|systemd)$'"
    ];
  };

  # Proxy systemd-bus notifications to libnotify
  services.systembus-notify.enable = true;

  # Auto-mounting
  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
  };

  services.devmon.enable = true;
  services.gvfs.enable = true; 

  # Nobody needs the default 4GB of logs...
  services.journald.extraConfig = ''
    SystemMaxUse=500M
  '';

  system.activationScripts.setPermissions = ''
    chown -R nick: {/projects,/blobs,/etc/nixos}
    chmod -R 700 {/projects,/blobs,/etc/nixos}
    rm -rf /home/nick/Downloads
  '';

  systemd = {
    # Started manually by hyprland
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };

    # Skip login only on TTY1 so lockscreen cannot be circumvented
    # https://github.com/NixOS/nixpkgs/issues/81552
    # https://discourse.nixos.org/t/autologin-for-single-tty/49427
    services."getty@tty1" = {
      overrideStrategy = "asDropin";
      serviceConfig.ExecStart = [
        ""
        "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login --autologin nick --noclear %I $TERM"
      ];
    };

    # TODO Switch to partition
    tmpfiles.rules = [
      "d /downloads 0755 nick"
    ];
  };

  # https://discourse.nixos.org/t/zfs-rollback-not-working-using-boot-initrd-systemd/37195/2
  boot.initrd.systemd.services.rollback = {
    description = "roolback rootfs on boot";
    wantedBy = [
      "initrd.target"
    ];
    after = [
      # This service is called zfs-import-<poolname>.service
      # Look up your poolname in disko.nix next time before debugging for 3 hours...
      "zfs-import-zroot.service"
    ];
    before = [
      "sysroot.mount"
    ];
    path = with pkgs; [
      zfs
    ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      zfs rollback -r zroot/root@blank
    '';
  };
}