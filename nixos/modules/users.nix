{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    backupFileExtension = "backup";
    users = {
      nick = import ../home-modules/home.nix;
    };
  };

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
}
