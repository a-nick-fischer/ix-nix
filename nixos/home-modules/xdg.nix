{
  pkgs,
  ...
}: {
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
      };
    };
  };
}