{ pkgs, inputs, outputs, config, ... }:

{ 
  imports = [
 #   inputs.stylix.homeManagerModules.stylix
  ];

  programs.home-manager.enable = true;

  home.username = "nick";
  home.homeDirectory = "/home/nick";

  # TODO Mime type registration is fucked...
  # See github desktop

  xdg = {
    enable = true;

    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
      ];
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "default-web-browser"           = [ "librewolf.desktop" ];
        "text/html"                     = [ "librewolf.desktop" ];
        "x-scheme-handler/http"         = [ "librewolf.desktop" ];
        "x-scheme-handler/https"        = [ "librewolf.desktop" ];
        "x-scheme-handler/about"        = [ "librewolf.desktop" ];
        "x-scheme-handler/unknown"      = [ "librewolf.desktop" ];
    } ;
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Make AGS happy
  nixpkgs.overlays = [
    (final: prev:
    {
      ags = prev.ags.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ pkgs.libdbusmenu-gtk3 ];
      });

      flameshot = prev.flameshot.override (old: {
        enableWlrSupport = true;
      });
    })
  ];

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
    pavucontrol
    helvum
    hyprpicker
    hyprlock
    brightnessctl

    # Notifications
    mako
    libnotify

    xdg-utils

    # Temp
    rofi-wayland

    git
    github-desktop

    # Make AGS happy
    gtk3
    gnome.adwaita-icon-theme

    # TODO enable client tor bridge https://nixos.wiki/wiki/Tor
    # TODO Containerize or Firejail
    # https://nixos.wiki/wiki/Tor_Browser_in_a_Container
    # https://nixos.wiki/wiki/Firejail#Torify_application_traffic
    tor-browser-bundle-bin

    # Maybe use grimblast... if I find a good image editor
    flameshot
    wl-clipboard
    grim
  ];

  services.flameshot = {
    enable = true;
    settings = {
      General = {
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

  home.stateVersion = "24.05"; # Please read the comment before changing.
}