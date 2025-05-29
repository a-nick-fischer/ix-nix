{ 
  pkgs,
  config,
  ... 
}:
{
  programs.firejail.enable = true;

  programs.wireshark.enable = true;

  programs.nh = {
    enable = true;
    flake = "/home/nick/.config/nixos";
  };

  programs.dconf.enable = true;

  programs.virt-manager.enable = true;

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  environment.systemPackages = with pkgs; [
    # Day-to-Day Programs
    onlyoffice-bin
    obsidian
    vesktop
    spotube
    buttercup-desktop
    krita
    signal-desktop
    obs-studio
    rnote
    thunderbird
    kando
    kitty
    boxbuddy
    apostrophe
    pwvucontrol

    # Gnome things
    gnome-secrets
    gnome-boxes
    warp
    impression
    diebahn
    resources
    dconf-editor
    eyedropper
    
    # Browsers
    librewolf 
    google-chrome
    tor-browser-bundle-bin

    # Tools
    wvkbd # Virtual Keyboard
    fzf
    jq
    macchanger
    wireplumber # Needed... I think... just leave it
    tldr
    nushell
    git
    btop
    distrobox
    docker-compose

    # IDEs
    vscodium-fhs
    jetbrains-toolbox
  ];

  services.xserver.excludePackages = with pkgs; [ 
    xterm 
  ];

  environment.gnome.excludePackages = with pkgs; [
      geary
      gnome-tour
      gnome-music
      gnome-console
      gnome-terminal
      gnome-contacts
      gnome-system-monitor
      totem
      gedit
      epiphany
  ];

  xdg.mime.defaultApplications = {
     "text/html" = "librewolf.desktop";
    "x-scheme-handler/http" = "librewolf.desktop";
    "x-scheme-handler/https" = "librewolf.desktop";
    "x-scheme-handler/about" = "librewolf.desktop";
    "x-scheme-handler/unknown" = "librewolf.desktop";
  };
}
