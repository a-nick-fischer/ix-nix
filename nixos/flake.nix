{
  description = "Nixos config flake";
     
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    disko = {
      url = "github:nix-community/disko";
    };

    home-manager = {
       url = "github:nix-community/home-manager";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    persist-retro = {
      url = "github:Geometer1729/persist-retro";
    };

    base16 = {
      url = "github:SenchoPens/base16.nix";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.base16.follows = "base16";
    };

    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      # Aparentelly hyprpaper hasn't got hyprland as a dependency
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins/v0.46.0";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland = {
     url = "github:hyprwm/Hyprland/v0.46.2";
    };

    ags = {
      url = "github:Aylur/ags/v1.8.2";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
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
