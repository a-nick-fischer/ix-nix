{ pkgs, inputs, ... }:
let
  librewolf-stable = inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.librewolf;
in
{
  programs.firejail.enable = true;

  programs.wireshark.enable = true;

  programs.pay-respects.enable = true;

  programs.nix-index-database.comma.enable = true;

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

  environment.systemPackages = with pkgs; [
    # Day-to-Day Programs
    onlyoffice-desktopeditors
    obsidian
    vesktop
    krita
    signal-desktop
    rnote
    thunderbird
    kitty
    pwvucontrol
    helvum
    keepassxc
    solaar

    # Gnome things
    gnome-secrets
    gnome-boxes
    impression
    resources
    eyedropper
    apostrophe
    refine

    # Browsers
    librewolf-bin
    google-chrome
    tor-browser

    # Tools
    fzf
    jq
    macchanger
    tldr
    git
    nixd
    alejandra

    # IDEs
    vscode-fhs
    jetbrains-toolbox

    # UI
    gnomeExtensions.pop-shell

    # 3D Printing & CNC
    super-slicer
    blender

    # Games
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
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    xdgOpenUsePortal = true;
  };
}
