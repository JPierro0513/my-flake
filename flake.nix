{
  description = "My personal flake of stuff I keep writting over and over again";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      # inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      # inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    neovim-nightly,
    ...
  }: {
    nixosModules = {
      default = ./modules;

      system = ./modules/system;
      nix-conf = ./modules/system/nix-config;
      shell = ./modules/system/shell;

      packages = ./modules/packages;
      development = ./modules/packages/development;
      editor = ./modules/packages/editor;

      # desktop = ./modules/desktop;
    };

    overlays.default = final: prev: {
      neovim = neovim-nightly.packages.${final.system}.default;
    };

    # packages = import ./packages;
  };
}
