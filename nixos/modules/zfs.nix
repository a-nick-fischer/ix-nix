{
  ...
}: {
  services = {
    fstrim.enable = true;

    zfs.autoScrub.enable = true;
  };
}