{ pkgs, inputs, outputs, config, ... }:

{ 
  imports = [
    inputs.hyprland.homeManagerModules.default
    inputs.ags.homeManagerModules.default
    ./overlays.nix
    ./xdg.nix
    ./packages.nix
    ./hyprland.nix
    ./hyprlock.nix
  ];
  
  programs.home-manager.enable = true;

  home.username = "nick";
  home.homeDirectory = "/home/nick";

  home.stateVersion = "24.05"; # Please read the comment before changing.
}
