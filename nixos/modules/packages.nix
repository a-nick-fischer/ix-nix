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
    xournalpp
    thunderbird
    kando
    kitty

    # Settings
    pavucontrol
    wdisplays
    
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

    # IDEs
    vscodium-fhs
    jetbrains.rust-rover
    jetbrains.idea-ultimate
  ];
}
