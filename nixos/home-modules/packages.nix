{
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Std-Software
    librewolf
    onlyoffice-bin
    obsidian
    ags
    nh
    devbox
    overskride
    ticktick
    kitty
    vscode
    buttercup-desktop
    hyprpaper
    hyprlock
    pavucontrol
    helvum
    hyprpicker
    brightnessctl

    # Notifications
    mako
    libnotify

    xdg-utils

    # Temp
    rofi-wayland

    vesktop
    spotify

    git
    github-desktop

    # Make AGS happy
    gtk3
    adwaita-icon-theme

    # TODO enable client tor bridge https://nixos.wiki/wiki/Tor
    # TODO Containerize or Firejail
    # https://nixos.wiki/wiki/Tor_Browser_in_a_Container
    # https://nixos.wiki/wiki/Firejail#Torify_application_traffic
    tor-browser-bundle-bin

    # Maybe use grimblast... if I find a good image editor
    flameshot
    wl-clipboard
    grim

    wvkbd
  ];

  services.flameshot = {
    enable = true;
    settings = {
      General = { # TODO Disable messages
        disabledTrayIcon = true;
        showStartupLaunchMessage = false;
      };
    };
  };

  programs.kitty.enable = true;

  programs.librewolf = {
    enable = true;
    settings = {
      # Note: Plugins are handled in-app
      "browser.download.dir" = "/downloads";
      "browser.policies.runOncePerModification.setDefaultSearchEngine" = "Startpage";

      # Enable DoH
      "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";
      "network.trr.mode" = 3;
    };
  };

  stylix = {
    enable = true;
    autoEnable = true;
  };
}