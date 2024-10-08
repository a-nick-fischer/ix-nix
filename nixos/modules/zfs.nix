{
  ...
}: {
    # ZFS
  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs.requestEncryptionCredentials = true;
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