{
  description = "Nixos config flake";
     
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    persist-retro = {
      url = "github:Geometer1729/persist-retro";
    };

    stylix = {
      url = "github:danth/stylix";
    };

    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland";
    };

    hyprfocus = {
      url = "github:pyt0xic/hyprfocus";
      inputs.hyprland.follows = "hyprland";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      # Aparentelly hyprpaper hasn't got hyprland as a dependency
    };

    xdg-desktop-portal-hyprland = {
      url = "github:hyprwm/xdg-desktop-portal-hyprland";
      # Doesn't follow hyprland neither
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };

    ags = {
      url = "github:Aylur/ags";
    };

    nix-mineral = {
      url = "github:cynicsketch/nix-mineral/v0.1.6-alpha";
      flake = false;
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs, 
    home-manager, 
    stylix, 
    ...
  } @ inputs:
  let 
    inherit (self) outputs;
  in {
    nixosConfigurations.ix = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs outputs; };
      modules = [
        inputs.impermanence.nixosModules.impermanence
        inputs.persist-retro.nixosModules.persist-retro
        inputs.home-manager.nixosModules.home-manager
        inputs.stylix.nixosModules.stylix
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.disko.nixosModules.default
        (import ./modules/disko.nix { device = "/dev/nvme0n1"; })

        ./modules/configuration.nix
      ];
    };
  };
}
