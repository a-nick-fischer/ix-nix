{
  pkgs,
  inputs,
  ...
}: {
  xdg = {
    enable = true;

    portal = {
      enable = true;
      
      extraPortals = [
	      #pkgs.xdg-desktop-portal-gtk
        inputs.hyprland.inputs.xdph.packages.${pkgs.system}.default
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
