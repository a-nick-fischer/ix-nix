{
  pkgs,
  ...
}: let 
  kando = pkgs.callPackage ./custom/kando.nix { };
in
{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Programs
    librewolf
    onlyoffice-bin
    obsidian
    pavucontrol
    vscode
    buttercup-desktop
    overskride
    ticktick
    helvum
    vesktop
    spotify
    github-desktop
    kitty
    gthumb
    nautilus
    wdisplays
    kooha
    krita
    mission-center
    vlc
    kando

    # TODO enable client tor bridge https://nixos.wiki/wiki/Tor
    # TODO Containerize or Firejail
    # https://nixos.wiki/wiki/Tor_Browser_in_a_Container
    # https://nixos.wiki/wiki/Firejail#Torify_application_traffic
    tor-browser-bundle-bin

    # Tools
    ags
    nh
    devbox
    hyprpaper
    brightnessctl
    xdg-utils
    #xdg-user-dirs
    git
    flameshot
    wvkbd
    fzf
    jq
    poppler
    macchanger

    # For Flameshot
    wl-clipboard
    grim

    # Fonts
    nerdfonts

    # Make AGS happy
    gtk3
    adwaita-icon-theme

    # Nix language server
    # https://github.com/oxalica/nil
    nil

    # Temp
    rofi-wayland
  ];

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        checkForUpdates = false;
        copyURLAfterUpload = false;
        showDesktopNotification = false;
        showHelp = false;
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

  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.nushell = {
    enable = true;
    extraConfig = ''
    $env.config.show_banner = false
    $env.config.table.mode = "light"
    $env.PROMPT_COMMAND = { $"(ansi red)(pwd)(ansi reset)" }
    $env.PROMPT_COMMAND_RIGHT = { $"(ansi red)(bash -c 'date +%d:%m:%H:%M:%S')(ansi reset)" }
    '';
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        (toString ../assets/main.png)
      ];

      wallpaper = [
        ", ${toString ../assets/main.png}"
      ];
    };
  };

  stylix = {
    enable = true;
    autoEnable = true;

    # For fancier borders...
    targets = {
      hyprland.enable = false;
      hyprpaper.enable = false;
    };
  };

  xdg.configFile = {
      "wluma/config.toml" = {
        text = ''
          [als.none]
          
          [[output.backlight]]
          name = "eDP-1"
          path = "/sys/class/backlight/intel_backlight"
          capturer = "wlroots"
          '';
      };
    };
}