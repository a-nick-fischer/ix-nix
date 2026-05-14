{
  pkgs,
  ...
}: {
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
    enable = true;
    remotePlay.openFirewall = true;
    protontricks.enable = true;
    gamescopeSession.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Day-to-Day Programs
    onlyoffice-desktopeditors
    obsidian
    discord
    pinta
    signal-desktop
    rnote
    thunderbird
    kitty
    aseprite
    keepassxc
    piper
    proton-vpn
    yubikey-personalization 

    # Audio
    easyeffects
    crosspipe

    # Gnome things
    gnome-boxes
    impression
    resources
    eyedropper
    refine
    gradia
    mousai
    blanket
    networkmanager-openconnect

    # Browsers
    librewolf
    google-chrome
    tor-browser

    # Tools
    fzf
    jq
    macchanger
    tealdeer
    git
    nixd
    alejandra
    podman-compose
    helix
    sbctl
    vt-cli
    jan

    # IDEs
    vscode-fhs
    jetbrains-toolbox

    # Games
    protonup-qt
  ];
}
