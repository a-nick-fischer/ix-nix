{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  users.mutableUsers = false;
  users.users."nick" = {
    isNormalUser = true;
    shell = pkgs.nushell;
    initialHashedPassword = "$y$j9T$8fEFURYXvsFCcIcPX5/4o0$U91T.17uI95SIWlerbecLpcek1VSEcYYrTH/2LDAJw.";
    extraGroups = [ "wheel" "wireshark" "firejail" "libvirtd" ];
  };

  environment.sessionVariables = {
    NH_FLAKE = "/home/nick/.config/nixos";
    DEFAULT_BROWSER = "${pkgs.librewolf}/bin/librewolf";
    BROWSER = "${pkgs.librewolf}/bin/librewolf";
    EDITOR = "${pkgs.vscode}/bin/code";
    XDG_CONFIG_HOME = "/home/nick/.config";
    OBSIDIAN_USE_WAYLAND = "1";
  };
}
