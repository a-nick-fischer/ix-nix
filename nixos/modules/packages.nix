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

  home.packages = with pkgs; [
    # Day-to-Day Programs
    onlyoffice-bin
    obsidian
    vesktop
    spotube
    buttercup-desktop
    krita
    signal-desktop
    obs-studio
    xournalpp
    thunderbird
    kando

    # Settings
    pavucontrol
    wdisplays
    
    # Browsers
    google-chrome
    tor-browser-bundle-bin

    # Tools
    wvkbd # Virtual Keyboard
    fzf
    jq
    macchanger
    wireplumber # Needed... I think... just leave it
    tldr

    # IDEs
    vscodium-fhs
    jetbrains.rust-rover
    jetbrains.idea-ultimate
  ];
}
