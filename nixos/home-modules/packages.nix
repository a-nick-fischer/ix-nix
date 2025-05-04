{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Day-to-Day Programs
    onlyoffice-bin
    obsidian
    vscode
    vesktop
    spotube
    buttercup-desktop
    krita
    signal-desktop
    wireshark
    obs-studio
    xournalpp
    thunderbird

    # Settings
    pavucontrol
    overskride
    wdisplays
    helvum
    cameractrls-gtk4
    
    # Basic OS functionality
    gthumb
    nemo
    vlc
    kando
    
    # Browsers
    google-chrome
    tor-browser-bundle-bin

    # Tools
    nh
    brightnessctl
    xdg-utils
    flameshot
    wvkbd # Virtual Keyboard
    fzf
    fd
    jq
    poppler # PDFs
    macchanger
    wireplumber # Needed... I think... just leave it
    clipse # Clipboard manager
    libnotify
    tldr
    
    # Secureboot
    sbctl

    # For Flameshot
    wl-clipboard
    grim

    # Fonts
    nerd-fonts.iosevka
    nerd-fonts.go-mono

    # Nix language server
    # https://github.com/oxalica/nil
    nil

    # IDEs
    jetbrains.rust-rover
    jetbrains.idea-ultimate
  ];

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        copyURLAfterUpload = false;
        showDesktopNotification = false;
        showHelp = false;
        disabledTrayIcon = true;
        showStartupLaunchMessage = false;
      };
    };
  };

  programs.btop.enable = true;

  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = false;
      confirm_os_window_close = 0;
    };
  };

  programs.git = {
    enable = true;
    userName= "Nick Fischer";
    userEmail = "me@nifi.blog";

    extraConfig = {
      # Sign all commits using ssh key
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      user.signingkey = "~/.ssh/id_ed25519.pub";
    };
  };

  # Install plugins:
  # uBlock Origin, Raindrop, NoScript, Firefox Relay, Startpage, LocalCDN
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

  # For virt-manager
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  stylix = {
    enable = true;
    autoEnable = true;
  };
}
