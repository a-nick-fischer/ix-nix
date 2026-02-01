{pkgs, ...}: {
  # Needed for Gnome
  services.xserver = {
    # Required for DE to launch.
    enable = true;

    xkb.layout = "de";

    # Exclude default X11 packages I don't want.
    excludePackages = with pkgs; [xterm];
  };

  services.desktopManager.gnome.enable = true;
  services.gnome.sushi.enable = true;

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

  environment.systemPackages = with pkgs; [ gnomeExtensions.pop-shell ];

  services.displayManager = {
    gdm.enable = true;

    autoLogin = {
      enable = true;
      user = "nick";
    };
  };

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