{
  description = "Nixos config flake";
     
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    stylix = {
      url = "github:danth/stylix";
    };

  };

  outputs = {nixpkgs, ...} @ inputs:
  {
    nixosConfigurations.ix = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        inputs.disko.nixosModules.default
        (import ./disko.nix { device = "/dev/nvme0n1"; })

        ./configuration.nix
              
        inputs.impermanence.nixosModules.impermanence
        inputs.stylix.nixosModules.stylix
      ];
    };
  };
}

