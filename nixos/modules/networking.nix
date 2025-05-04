{
  lib,
  ...
}: {
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking = {
    hostName = "ix"; # Define your hostname.
    hostId = "fff69420";
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;

    firewall = {
      allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
    };
  };
}