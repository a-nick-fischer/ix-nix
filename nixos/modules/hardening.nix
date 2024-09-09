{
 ... 
}: 
{
  ##################################################
  # Aggresively harden using nix-mineral
  ##################################################
  imports = [
    ./mineral.nix
  ];

  ##################################################
  # Filesystem hardening
  ##################################################

  fileSystems = {
    "/blobs" = {
        options = [
          "bind"
          "nosuid"
          "noexec"
          "nodev"
        ];
    };

    # TODO: Uncomment later..
    #"/downloads" = {
    #    options = [
    #      "bind"
    #      "nosuid"
    #      "noexec"
    #      "nodev"
    #    ];
    #};

    "/persist" = {
        options = [
          "bind"
          "nosuid"
          "noexec"
          "nodev"
        ];
    };
  };

  ##################################################
  # Configure DoH
  ##################################################
  # See https://nixos.wiki/wiki/Encrypted_DNS
  services.resolved.enable = false;

  networking = {
    nameservers = [ "127.0.0.1" "::1" ];
    networkmanager.dns = "none";
  };

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };

  
}