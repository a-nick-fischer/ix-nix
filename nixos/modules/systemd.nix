{
  pkgs,
  ...
}: {
  security.polkit.enable = true;
  services.dbus.implementation = "broker";

  # Auto-mounting
  services.udisks2.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true; 

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

    services.macchanger = {
      description = "Randomize MAC address of wlan0";
      wants = [ "network-pre.target" ];
      wantedBy = [ "multi-user.target" ];
      before = [ "network-pre.target" ];
      bindsTo = [ "sys-subsystem-net-devices-wlan0.device" ];
      after = [ "sys-subsystem-net-devices-wlan0.device" ];
      script = ''
        ${pkgs.macchanger}/bin/macchanger wlan0 --another
        '';
      serviceConfig.Type = "oneshot";
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