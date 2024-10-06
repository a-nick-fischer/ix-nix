{
  lib,
  ...
}: {
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking = {
    hostName = "ix"; # Define your hostname.
    hostId = "fff69420";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    #nftables.enable = true;

    firewall = {
      allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
    };

    wg-quick.interfaces = {
      wg-proton-nl = {
        address = [ "10.2.0.2/32" ];
        listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

        privateKeyFile = "~/.config/secrets/wg-proton-nl-private-key";

        dns = [ "10.2.0.1" ];

        postUp = ''
          notify-send "[WIREGUARD UP]" "We're secure-ish now" --icon=network-vpn-symbolic -t 2000
        '';

        postDown = ''
          notify-send "[WIREGUARD DOWN]" "Down we go..." --icon=network-vpn-disabled-symbolic -t 2000
        '';

        peers = [
          {
            # Public key of the server (not a file path).
            publicKey = "61WWXAHmcDtQcR2JLaGEjOIdDBdYPll7qMtRNPRkOlg=";

            # Forward all the traffic via VPN.
            allowedIPs = [ "0.0.0.0/0" "::/0" ];

            endpoint = "185.107.56.219:51820"; 

            # Send keepalives every 25 seconds. Important to keep NAT tables alive.
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  # Prevent auto-start without removing the service entirely.
  systemd.services.wg-quick-wg-proton-nl.wantedBy = lib.mkForce [ ];
}