{pkgs, ...}: 
let
  zfsPackage = pkgs.zfs_2_4;
in
{
  # ZFS
  boot = {
    supportedFilesystems = ["zfs"];


    zfs = {
      package = zfsPackage;
      requestEncryptionCredentials = true;
    };

    # https://discourse.nixos.org/t/zfs-rollback-not-working-using-boot-initrd-systemd/37195/2
    initrd.systemd.services.rollback = {
      description = "roolback rootfs on boot";
      wantedBy = ["initrd.target"];

      # This service is called zfs-import-<poolname>.service
      # Look up your poolname in disko.nix next time before debugging for 3 hours...
      after = ["zfs-import-zroot.service"];

      before = ["sysroot.mount"];

      path = [zfsPackage];

      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        zfs rollback -r zroot/root@blank
      '';
    };
  };

  services = {
    fstrim.enable = true;

    zfs.autoScrub.enable = true;

    zfs.autoSnapshot = {
      enable = true;

      # Use UTC time for snapshots, quote from options:
      # If it’s not too inconvenient for snapshots to have timestamps in UTC,
      # it is suggested that you append --utc to the list of default options (see example).
      # Otherwise, snapshot names can cause name conflicts or apparent time reversals due to
      # daylight savings, timezone or other date/time changes.
      flags = "--utc";

      # Keep one montly, weekly, daily, hourly and 15min-snapshot each
      monthly = 1;
      weekly = 1;
      daily = 1;
      hourly = 1;
      frequent = 1;
    };
  };
}
