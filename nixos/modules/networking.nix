{
  lib,
  ...
}: {
  networking = {
    hostName = "ix"; # Define your hostname.
    hostId = "fff69420";
    networkmanager.enable = true;
    firewall.enable = true;
    useDHCP = lib.mkDefault true;
  };
}