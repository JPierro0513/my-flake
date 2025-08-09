{
  lib,
  config,
  pkgs,
  ...
}:
with lib; {
  options.personal.development = {
    enable = mkEnableOption "development tools and languages";

    languages = {
      rust = mkEnableOption "Rust development tools";
      lua = mkEnableOption "Lua development tools";
      nix = mkEnableOption "Nix development tools";
      c = mkEnableOption "C/C++ development tools";
    };

    tools = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Additional development tools to install";
    };
  };

  config = mkIf config.personal.development.enable {
    environment.systemPackages = with pkgs;
      [
        gh
        wget
        curl
        package-version-server
      ]
      ++ optionals config.personal.development.languages.c [
        clang
        clang-tools
        cmake
        ninja
        pkg-config
      ]
      ++ optionals config.personal.development.languages.lua [
        lua
        lua-language-server
        stylua
      ]
      ++ optionals config.personal.development.languages.rust [
        rustup
        rust-analyzer
      ]
      ++ optionals config.personal.development.languages.nix [
        nil
        nixd
        alejandra
      ]
      ++ config.personal.development.tools;

    programs.nix-ld = mkIf (config.personal.development.languages.c) {
      enable = true;
      # libraries = with pkgs; [
      #   libpng
      #   libusb1
      #   libclang
      # ];
    };
  };
}
