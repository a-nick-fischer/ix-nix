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

      config.common.default = "*";
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
          command_path="$out/bin/$(basename ${executable})"
          mkdir -p $out/bin
          mkdir -p $out/share/applications
          cat <<'_EOF' >"$command_path"
          #! ${prev.bash}/bin/bash -e
          exec /run/current-system/sw/bin/nvidia-offload ${toString executable} "$@"
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

      toggleKeyboard = prev.runCommand "output.txt" {} ''
        
      '';
    })
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    systemd = {
      enable = true;
      enableXdgAutostart = true;
    };

    settings = {
      # Monitors
      monitor = ",preferred,auto,1";

      # Vars
      "$terminal" = "kitty";
      "$menu" = "rofi -show drun -show-icons";

      # Autostart
      exec-once = [ "systemctl start --user polkit-gnome-authentication-agent-1" ];

      # Environment
      env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
          "LIBVA_DRIVER_NAME,nvidia"
          "XDG_SESSION_TYPE,wayland"
          "GBM_BACKEND,nvidia-drm"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
          "NIXOS_OZONE_WL,1"
      ];

      # Look and Feel
      general = { 
          gaps_in = 5;
          gaps_out = 20;

          border_size = 2;

          resize_on_border = false;

          allow_tearing = false;

          layout = "dwindle";
      };


      decoration = {
          rounding = 10;

          active_opacity = 1.0;
          inactive_opacity = 1.0;

          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;

          blur = {
              enabled = true;
              size = 3;
              passes = 1;
              vibrancy = 0.1696;
          };
      };


      animations = {
          enabled = true;

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
      };

      dwindle = {
          pseudotile = true;
          preserve_split = true;
      };


      # Keyboard
      input = {
          kb_layout = "de";

          follow_mouse = 1;
          sensitivity = 0;

          touchpad = {
              natural_scroll = false;
          };
      };

      # Touchpad
      gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 4;
      };

      # Keybinds
      "$mainMod" = "SUPER";

      bind = [
          "$mainMod, PERIOD, exec, $terminal"
          "$mainMod, Q, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, V, togglefloating,"
          "$mainMod, RETURN, fullscreen"
          "$mainMod, MINUS, exec, $menu"
          "$mainMod, P, pseudo," # dwindle
          "$mainMod, J, togglesplit," # dwindle

          # Move focus with mainMod + arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          # Example special workspace (scratchpad)
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"

          # Sound
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

          # Clipboard
          ", Print, exec, flameshot gui --raw | wl-copy"
          "$mainMod, Print, exec, flameshot gui"

          # Plugins
          "$mainMod, Tab, hyprexpo:expo, toggle"
      ];

      bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
      ];

      binde = [
          # Sound
          ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"

          # Brightness
          ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
          ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
      ];

      # Touchscreen
      plugin = {
        touch_gestures = {
            #sensitivity = 1.0

            workspace_swipe_fingers = 3;

            long_press_delay = 400;

            gestures = {
                workspace_swipe = true;
                workspace_swipe_cancel_ratio = 0.05;
            };

            hyprgrass-bind = [
              ", swipe:3:u, exec, $menu"
              ", swipe:4:u, exec, wvkbd-mobintl -L 300 --fn 0xProto --alpha 128"
            ];
        };

        #hyprexpo = {
        #
        #};
      };

      # Window Rules
      windowrulev2 = ["suppressevent maximize, class:.*"];

    };

    plugins = [
      inputs.hyprgrass.packages.${pkgs.system}.default
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
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
    adwaita-icon-theme

    # TODO enable client tor bridge https://nixos.wiki/wiki/Tor
    # TODO Containerize or Firejail
    # https://nixos.wiki/wiki/Tor_Browser_in_a_Container
    # https://nixos.wiki/wiki/Firejail#Torify_application_traffic
    tor-browser-bundle-bin

    # Maybe use grimblast... if I find a good image editor
    flameshot
    wl-clipboard
    grim

    wvkbd
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
