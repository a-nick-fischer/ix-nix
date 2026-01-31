{lib, ...}: {
  ##################################################
  # General
  ##################################################
  # We're borrowing things from nix-mineral, the whole config is a bit overkill
  # See https://github.com/cynicsketch/nix-mineral/blob/main/nix-mineral.nix
  #
  # Some things are also borrowed from https://saylesss88.github.io/nix/hardening_NixOS.html
  boot = {
    kernel.sysctl = {
      # enable ASLR
      # turn on protection and randomize stack, vdso page and mmap + randomize brk base address
      "kernel.randomize_va_space" = "2";
    };

    # Disable the editor in systemd-boot, the default bootloader for NixOS.
    # This prevents access to the root shell or otherwise weakening
    # security by tampering with boot parameters. If you use a different
    # boatloader, this does not provide anything. You may also want to
    # consider disabling similar functions in your choice of bootloader.
    loader.systemd-boot.editor = false;
  };

  environment.etc = {
    # Empty /etc/securetty to prevent root login on tty.
    securetty.text = ''
      # /etc/securetty: list of terminals on which root is allowed to login.
      # See securetty(5) and login(1).
    '';

    # Set machine-id to the Kicksecure machine-id, for privacy reasons.
    # /var/lib/dbus/machine-id doesn't exist on dbus enabled NixOS systems,
    # so we don't have to worry about that.
    machine-id.text = ''
      b08dfa6083e7567a1921a715000001fb
    '';
  };

  # Limit access to nix to users with the "wheel" group. ("sudoers")
  nix.settings.allowed-users = lib.mkForce ["@wheel"];

  ##################################################
  # NETWORKING
  ##################################################

  # Sysctl (mostly from nix-mineral)
  ##################################################
  boot.kernel.sysctl = {
    # always use the best local address for announcing local IP via ARP
    # Seems to be most restrictive option
    "net.ipv4.conf.default.arp_announce" = "2";
    "net.ipv4.conf.all.arp_announce" = "2";

    # reply only if the target IP address is local address configured on the incoming interface
    "net.ipv4.conf.default.arp_ignore" = "1";
    "net.ipv4.conf.all.arp_ignore" = "1";

    # ignore all ICMP echo and timestamp requests sent to broadcast/multicast
    "net.ipv4.icmp_echo_ignore_broadcasts" = "1";

    # number of Router Solicitations to send until assuming no routers are present
    "net.ipv6.conf.default.router_solicitations" = "0";
    "net.ipv6.conf.all.router_solicitations" = "0";

    # do not accept Router Preference from RA
    "net.ipv6.conf.default.accept_ra_rtr_pref" = "0";
    "net.ipv6.conf.all.accept_ra_rtr_pref" = "0";

    # learn prefix information in router advertisement
    "net.ipv6.conf.default.accept_ra_pinfo" = "0";
    "net.ipv6.conf.all.accept_ra_pinfo" = "0";

    # setting controls whether the system will accept Hop Limit settings from a router advertisement
    "net.ipv6.conf.default.accept_ra_defrtr" = "0";
    "net.ipv6.conf.all.accept_ra_defrtr" = "0";

    # router advertisements can cause the system to assign a global unicast address to an interface
    "net.ipv6.conf.default.autoconf" = "0";
    "net.ipv6.conf.all.autoconf" = "0";

    # number of neighbor solicitations to send out per address
    "net.ipv6.conf.default.dad_transmits" = "0";
    "net.ipv6.conf.all.dad_transmits" = "0";

    # number of global unicast IPv6 addresses can be assigned to each interface
    "net.ipv6.conf.default.max_addresses" = "1";
    "net.ipv6.conf.all.max_addresses" = "1";
  };

  # Configure DoH
  ##################################################
  # See https://nixos.wiki/wiki/Encrypted_DNS
  services.resolved.enable = false;

  networking = {
    nameservers = ["127.0.0.1" "::1"];
    networkmanager.dns = "none";
  };

  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };

  # Firewall
  ##################################################
  networking.firewall.enable = true;

  # Networkmanager
  ##################################################
  networking.networkmanager = {
    ethernet.macAddress = "random";

    wifi = {
      macAddress = "random";
      scanRandMacAddress = true;
    };

    # Enable IPv6 privacy extensions in NetworkManager.
    connectionConfig."ipv6.ip6-privacy" = 2;
  };

  systemd.network.config.networkConfig.IPv6PrivacyExtensions = "kernel";

  # Memory Allocator
  ##################################################
  environment.memoryAllocator.provider = "graphene-hardened-light";
}
