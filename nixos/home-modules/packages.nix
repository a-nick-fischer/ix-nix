{
  pkgs,
  inputs,
  ...
}: let 
  kando = pkgs.callPackage ./custom/kando.nix { };
in
{
  nixpkgs.config.allowUnfree = true;


  home.packages = with pkgs; [
    # Programs
    onlyoffice-bin
    obsidian
    pavucontrol
    vscode
    buttercup-desktop
    overskride
    ticktick
    vesktop
    spotify
    github-desktop
    gthumb
    nautilus
    wdisplays
    kooha
    krita
    mission-center
    vlc
    kando
    signal-desktop
    wireshark
    obs-studio
    helvum
    cameractrls-gtk4
    google-chrome
    
    # TODO enable client tor bridge https://nixos.wiki/wiki/Tor
    # TODO Containerize or Firejail
    # https://nixos.wiki/wiki/Firejail#Torify_application_traffic
    tor-browser-bundle-bin

    # Tools
    nh
    brightnessctl
    xdg-utils
    git
    flameshot
    wvkbd
    fzf
    jq
    poppler
    macchanger
    wireplumber # Needed... I think... just leave it
    hyprshade
    clipse
    libnotify
    
    # Secureboot
    sbctl

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

  programs.ags.enable = true;

  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };
  };

  programs.librewolf = {
    enable = true;
    settings = {
      # Note: Plugins are handled in-app
      "browser.download.dir" = "/downloads";

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
    package = inputs.hyprpaper.packages.${pkgs.system}.default;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "~/.config/nixos/assets/main.png"
        "~/.config/nixos/assets/empty.png"
      ];

      wallpaper = [
        ", ~/.config/nixos/assets/main.png"
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
}