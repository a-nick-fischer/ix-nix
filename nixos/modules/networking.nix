{
  ...
}: {
  networking = {
    hostName = "ix"; # Define your hostname.
    hostId = "fff69420";
    networkmanager.enable = true;
    useDHCP = true;
  };
}