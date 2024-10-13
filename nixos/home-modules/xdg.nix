{
  ...
}: 
let 
  browser = ["librewolf.desktop"];

  associations = {
    "default-web-browser" = browser;
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/xhtml+xml" = browser;
    "application/x-extension-xhtml" = browser;
    "application/x-extension-xht" = browser;
    "application/json" = browser;
    "application/pdf" = browser;
    "audio/*" = ["vlc.desktop"];
    "video/*" = ["vlc.dekstop"];
    "image/*" = ["gthumb.desktop"];
  };
in
{
  xdg = {
    enable = true;

    mimeApps = {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };
  };
}
