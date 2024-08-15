{
  pkgs,
  ...
}: {
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
    git
    flameshot
    wvkbd
    fzf
    jq
    poppler
    macchanger
    mission-center

    # For Flameshot
    wl-clipboard
    grim

    # FOnts
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

  # TODO https://gist.github.com/endofunky/f9c97c467a37d4e53adaa329835d661e

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

  stylix = {
    enable = true;
    autoEnable = true;
  };
}