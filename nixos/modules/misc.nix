{
  inputs,
  outputs,
  pkgs,
  config,
  ...
}: {
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    backupFileExtension = "backup";
    users = {
      nick = import ../home-modules/home.nix;
    };
  };

  # TODO Reverse-engineer https://github.com/vimjoyer/nixconf/tree/main
  users.mutableUsers = false;
  users.users."nick" = {
    isNormalUser = true;
    shell = pkgs.nushell;
    initialHashedPassword = "$y$j9T$8fEFURYXvsFCcIcPX5/4o0$U91T.17uI95SIWlerbecLpcek1VSEcYYrTH/2LDAJw.";
    extraGroups = [ "wheel" "wireshark" "firejail" ];
  };

  environment.sessionVariables = {
    FLAKE = "/home/nick/.config/nixos";
    DEFAULT_BROWSER = "${pkgs.librewolf}/bin/librewolf";
    BROWSER = "${pkgs.librewolf}/bin/librewolf";
    EDITOR = "${pkgs.vscode}/bin/code";
    XDG_CONFIG_HOME = "/home/nick/.config";
  };

  security.pam.services.hyprlock = {};

  programs.firejail.enable = true;

  programs.wireshark.enable = true;

  programs.hyprland = {
    enable = true;

    portalPackage = inputs.hyprland.packages."${pkgs.system}".xdg-desktop-portal-hyprland;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "light";
    image = config.lib.stylix.pixel "base0A";

    #https://rosepinetheme.com/themes/
    #https://github.com/tinted-theming/schemes/blob/spec-0.11/base16/rose-pine-moon.yaml
    #https://github.com/tinted-theming/schemes/blob/spec-0.11/base16/rose-pine-dawn.yaml
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-dawn.yaml";

    cursor.package = pkgs.rose-pine-cursor;
    cursor.name = "BreezeX-RosePine-Linux";

    # Surpress invalid yaml files
    override.use-ifd = "always";

    fonts = {
      monospace = {
        package = pkgs._0xproto;
        name = "0xProto";
      };
    };
  };
}
