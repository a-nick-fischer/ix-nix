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
    hyprsunset
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

    extraLogin = ''
     if (tty) == "/dev/tty1" and (uwsm check may-start | complete).exit_code == 0 {
       exec systemd-cat -t uwsm_start uwsm start default
     }
    '';
  };

  services.swaync = {
    enable = true;
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

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.main = {
      layer = "top";

      modules-left = [
        "hyprland/workspaces" 
      ];

      modules-center = [
        "clock"
      ];

      modules-right = [
        "battery"
        "network"
        "bluetooth"
        "pulseaudio"
      ];

      "hyprland/workspaces" = {
        "active-only" = true;
        "disable-scroll" = true;
        "sort-by-number" = true;
        "on-click" = "activate";
        "persistent-workspaces" = {
          "*" = 3;
        };
      };

      "hyprland/window" = {
        "format" = "{title}";
        "max-length" = 50;
      };

      battery = {
        format = "{capacity}% {icon}";

        states = {
          "good" = 95;
          "warning" = 30;
          "critical" = 15;
        };
      };

      tray = {
        format = "<span foreground='#ebdbb2'>{icon}</span>";
     	  icon-size = 14;
     	  spacing = 5;
     };

      clock = {
          format-alt = "{:%a, %d. %b  %H:%M}";
      };
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
