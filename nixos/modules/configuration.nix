# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ ... }:

{
  imports =
    [
      ./auxillary.nix
      ./boot.nix
      ./hardening.nix
      ./hardware.nix
      ./impermanance.nix
      ./networking.nix
      ./nixos.nix
      ./nvidia.nix
      ./packages.nix
      ./power.nix
      ./services.nix
      ./time.nix
      ./users.nix
      ./virtualisation.nix
      ./zfs.nix
    ];
}
