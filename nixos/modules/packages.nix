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
    package = pkgs.valent;
  };

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      droidcam-obs
    ];
  };

  environment.systemPackages = with pkgs; [
    # Day-to-Day Programs
    onlyoffice-bin
    obsidian
    vesktop
    buttercup-desktop
    krita
    signal-desktop
    rnote
    thunderbird
    kando
    kitty
    boxbuddy
    pwvucontrol
    wifi-qr
    helvum
    maestral-gui
    realvnc-vnc-viewer

    # Gnome things
    gnome-secrets
    gnome-boxes
    warp
    impression
    diebahn
    resources
    dconf-editor
    eyedropper
    apostrophe
    zenity # Needed for wifi-qr
    
    # Browsers
    librewolf 
    google-chrome
    tor-browser-bundle-bin

    # Tools
    fzf
    jq
    macchanger
    tldr
    nushell
    git
    btop
    distrobox
    docker-compose
    maestral

    # IDEs
    vscode-fhs
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
