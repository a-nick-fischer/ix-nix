{ pkgs, inputs, outputs, config, ... }:

{ 
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];
  
  programs.home-manager.enable = true;

  home.username = "nick";
  home.homeDirectory = "/home/nick";

  # TODO Mime type registration is fucked...
  # See github desktop

  xdg = {
    enable = true;

    portal = {
      enable = true;
      extraPortals = [
	      #pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
      ];
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        "default-web-browser"           = [ "librewolf.desktop" ];
        "text/html"                     = [ "librewolf.desktop" ];
        "x-scheme-handler/http"         = [ "librewolf.desktop" ];
        "x-scheme-handler/https"        = [ "librewolf.desktop" ];
        "x-scheme-handler/about"        = [ "librewolf.desktop" ];
        "x-scheme-handler/unknown"      = [ "librewolf.desktop" ];
    } ;
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Make AGS happy
  nixpkgs.overlays = [
    (final: prev:
    let 
      # Based on https://www.reddit.com/r/NixOS/comments/1b56jdx/simple_nix_function_for_wrapping_executables_with/
      nvidiaOffloadWrap = { executable, desktop ? null }: prev.runCommand "nvidia-offload"
      {
        preferLocalBuild = true;
        allowSubstitutes = false;
        meta.priority = -1; # take precedence over non-firejailed versions
      }
      (
        ''
          command_path="$out/bin/$(basename ${executable})-lol"
          mkdir -p $out/bin
          mkdir -p $out/share/applications
          cat <<'_EOF' >"$command_path"
          #! ${prev.runtimeShell} -e
          exec /run/current-system/sw/bin/nvidia-offload ${toString executable} "\$@"
          _EOF
          chmod 0755 "$command_path"
        '' + prev.lib.optionalString (desktop != null) ''
          substitute ${desktop} $out/share/applications/$(basename ${desktop}) \
            --replace ${executable} "$command_path"
        ''
      );
    in
    {
      ags = prev.ags.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ pkgs.libdbusmenu-gtk3 ];
      });

      flameshot = prev.flameshot.override (old: {
        enableWlrSupport = true;
      });
      
      kitty = nvidiaOffloadWrap {
        executable = "${prev.kitty}/bin/kitty";
        desktop = "${prev.kitty}/share/applications/kitty.desktop"; # TODO There's another one..
      };
    })
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    systemd = {
      enable = true;
      enableXdgAutostart = true;
    };

    settings = {};

    plugins = [
    #  inputs.hyprgrass.packages.${pkgs.system}.default
    #  inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];
  };

  # TODO Offload obsidian to GPU?
  # Do it via nvidia settings file...

  home.packages = with pkgs; [
    # Std-Software
    librewolf
    onlyoffice-bin
    obsidian
    ags
    nh
    devbox
    overskride
    ticktick
    kitty
    vscode
    buttercup-desktop
    hyprpaper
    pavucontrol
    helvum
    hyprpicker
    hyprlock
    brightnessctl

    # Notifications
    mako
    libnotify

    xdg-utils

    # Temp
    rofi-wayland

    git
    github-desktop

    # Make AGS happy
    gtk3
    gnome.adwaita-icon-theme

    # TODO enable client tor bridge https://nixos.wiki/wiki/Tor
    # TODO Containerize or Firejail
    # https://nixos.wiki/wiki/Tor_Browser_in_a_Container
    # https://nixos.wiki/wiki/Firejail#Torify_application_traffic
    tor-browser-bundle-bin

    # Maybe use grimblast... if I find a good image editor
    flameshot
    wl-clipboard
    grim
  ];

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        disabledTrayIcon = true;
        showStartupLaunchMessage = false;
      };
    };
  };

  programs.kitty.enable = true;

  programs.librewolf = {
    enable = true;
    settings = {
      # Note: Plugins are handled in-app
      "browser.download.dir" = "/downloads";
      "browser.policies.runOncePerModification.setDefaultSearchEngine" = "Startpage";

      # Enable DoH
      "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";
      "network.trr.mode" = 3;
    };
  };

  stylix = {
    enable = true;
    autoEnable = true;
  };

  home.stateVersion = "24.05"; # Please read the comment before changing.
}
