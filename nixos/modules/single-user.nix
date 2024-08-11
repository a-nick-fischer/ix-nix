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

  # TODO https://github.com/Geometer1729/persist-retro
  # TODO Reverse-engineer https://github.com/vimjoyer/nixconf/tree/main

  users.users."nick" = {
    isNormalUser = true;
    shell = pkgs.nushell;
    initialPassword = "nixos"; # TODO find a better way
    extraGroups = [ "wheel" ];
  };

  environment.sessionVariables = {
    FLAKE = "/home/nick/.config/nixos";
    DEFAULT_BROWSER = "${pkgs.librewolf}/bin/librewolf";
    BROWSER = "${pkgs.librewolf}/bin/librewolf";
    EDITOR = "${pkgs.vscode}/bin/code";
  };

  programs.hyprland = {
     enable = true;
     package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };

  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "light";
    image = config.lib.stylix.pixel "base0A";

    # TODO rose-pine-icon-theme

    #https://rosepinetheme.com/themes/
    #https://github.com/tinted-theming/schemes/blob/spec-0.11/base16/rose-pine-moon.yaml
    #https://github.com/tinted-theming/schemes/blob/spec-0.11/base16/rose-pine-dawn.yaml
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-dawn.yaml";

    cursor.package = pkgs.rose-pine-cursor;
    cursor.name = "BreezeX-RosePine-Linux";

    fonts = {
      monospace = {
        package = pkgs._0xproto;
        name = "0xProto";
      };
    };
  };
}