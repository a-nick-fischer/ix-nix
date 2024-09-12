{ ... }: {
  time.timeZone = "Europe/Vienna";

  # Get our time via NTS
  services.timesyncd.enable = false;
  services.chrony = {
    enable = true;
    
    enableNTS = true;
    
    # From https://github.com/GrapheneOS/infrastructure/blob/main/chrony.conf
    extraConfig = ''
    server time.cloudflare.com iburst nts
    server ntppool1.time.nl iburst nts
    server nts.netnod.se iburst nts
    server ptbtime1.ptb.de iburst nts
    server time.dfm.dk iburst nts
    server time.cifelli.xyz iburst nts

    minsources 3
    authselectmode require

    # EF
    dscp 46

    driftfile /var/lib/chrony/drift
    ntsdumpdir /var/lib/chrony

    leapsectz right/UTC
    makestep 1.0 3

    rtconutc
    rtcsync

    cmdport 0

    noclientlog
    '';
  };
}