{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.android_sdk.accept_license = true;

  home.packages = with pkgs; [
    # Day-to-Day Programs
    onlyoffice-bin
    obsidian
    vscode
    ticktick
    vesktop
    spotify
    github-desktop
    buttercup-desktop
    kooha
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
    ulauncher
    
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
    hyprshade # Blue light filter
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

    # Make AGS happy
    gtk3
    adwaita-icon-theme

    # Nix language server
    # https://github.com/oxalica/nil
    nil

    # IDEs
    jetbrains.goland
    jetbrains.idea-community
    bruno
    bruno-cli
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

  programs.ags.enable = true;

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

    extraLogin = ''
     if (tty) == "/dev/tty1" and (uwsm check may-start | complete).exit_code == 0 {
       exec systemd-cat -t uwsm_start uwsm start default
     }
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

    # For fancier borders...
    targets = {
      hyprland.enable = false;
      hyprpaper.enable = false;
      hyprlock.enable = false;
    };
  };
}
