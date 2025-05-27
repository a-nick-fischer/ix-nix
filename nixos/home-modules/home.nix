{ ... }:

{ 
  imports = [
    ./overlays.nix
    # TODO ./xdg.nix
    ./packages.nix
  ];
  
  programs.home-manager.enable = true;

  home.username = "nick";
  home.homeDirectory = "/home/nick";

  home.stateVersion = "25.05"; # Please read the comment before changing.
}
