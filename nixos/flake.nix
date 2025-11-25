{
  description = "Nixos config flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    disko = {
      url = "github:nix-community/disko";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    persist-retro = {
      url = "github:Geometer1729/persist-retro";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations.ix = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs;};
      modules = [
        inputs.impermanence.nixosModules.impermanence
        inputs.persist-retro.nixosModules.persist-retro
        inputs.disko.nixosModules.default
        inputs.nix-index-database.nixosModules.nix-index
        (import ./modules/disko.nix {})

        ./modules/configuration.nix
      ];
    };
  };
}
