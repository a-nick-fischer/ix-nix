{lib, ...}: {
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking = {
    hostName = "ix"; # Define your hostname.
    hostId = "fff69420";
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
  };
}
