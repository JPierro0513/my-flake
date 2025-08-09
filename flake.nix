{
  description = "My personal flake of stuff I keep writting over and over again";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    home-manager,
    neovim-nightly,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      # pkgs = import nixpkgs {
      #   inherit system;
      #   config.allowUnfree = true;
      #   overlays = [
      #     neovim-nightly.overlays.default
      #   ];
      # };
    in {
      nixosModules = {
        default = ./modules;
        system = ./modules/system;
        packages = ./modules/packages;
        # desktop = ./modules/desktop;
      };

      overlays.default = import ./overlays;

      # packages = import ./packages;
    });
}
