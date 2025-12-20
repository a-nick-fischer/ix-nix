{ lib, pkgs, ... }: {
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking = {
    hostName = "ix"; # Define your hostname.
    hostId = "fff69420";
    useDHCP = lib.mkDefault true;
    networkmanager = {
      enable = true;

      # Prefer wlan1 over wlan0 by assigning lower route metrics to wlan1.
      dispatcherScripts = [
        {
          source = pkgs.writeShellScript "nm-prefer-wlan1" ''
            #!/run/current-system/sw/bin/bash
            set -euo pipefail

            IFACE="$1"
            ACTION="$2"

            case "$ACTION" in
              up|dhcp4-change|dhcp6-change|connectivity-change)
                case "$IFACE" in
                  wlan1)
                    /run/current-system/sw/bin/nmcli device modify "$IFACE" ipv4.route-metric 100 ipv6.route-metric 100 || true
                    ;;
                  wlan0)
                    /run/current-system/sw/bin/nmcli device modify "$IFACE" ipv4.route-metric 600 ipv6.route-metric 600 || true
                    ;;
                esac
                ;;
            esac
          '';
        }
      ];
    };
  };
}
