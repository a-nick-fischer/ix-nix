{lib, ...}: {
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking = {
    hostName = "ix"; # Define your hostname.
    hostId = "fff69420";
    useDHCP = lib.mkDefault true;
    networkmanager = {
      enable = true;
      connectionConfig = {
        internal-wifi-card = {
          type = "wifi";
          interface-name = "wlan0";
          ipv4.route-metric = 600;
        };

        external-wifi-antenna = {
          type = "wifi";
          interface-name = "wlan1";
          ipv4.route-metric = 100;
        };
      };
    };
  };
}
