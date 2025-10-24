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

  programs.gamemode.enable = true; 

  programs.steam = {
    enable = true; # install steam
    remotePlay.openFirewall = true;
    protontricks.enable = true;
    gamescopeSession.enable = true;
  };

  # Needed for geforce now
  nixpkgs.config.permittedInsecurePackages = [
    "electron-35.7.5"
  ];

  environment.systemPackages = with pkgs; [
    # Day-to-Day Programs
    onlyoffice-bin
    obsidian
    vesktop
    krita
    signal-desktop
    rnote
    thunderbird
    kitty
    boxbuddy
    pwvucontrol
    helvum

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
    foliate
    
    # Browsers
    librewolf 
    google-chrome
    tor-browser-bundle-bin

    # Tools
    fzf
    jq
    macchanger
    tldr
    git
    btop
    distrobox

    # IDEs
    vscode-fhs
    jetbrains-toolbox

    # UI
    gnomeExtensions.pop-shell

    # 3D Printing & CNC
    super-slicer
    blender

    # Games
    gfn-electron
    cartridges
    protonup-qt
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

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
  };
}
