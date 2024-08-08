{
  pkgs,
  ...
}: {
  security.polkit.enable = true;
  services.dbus.implementation = "broker";

  system.activationScripts.setPermissions = ''
    chown -R nick: {/projects,/blobs,/etc/nixos}
    chmod -R 700 {/projects,/blobs,/etc/nixos}
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