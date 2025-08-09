{
  lib,
  config,
  inputs,
  ...
}:
with lib; {
  options.personal.nix-config = {
    enable = mkEnableOption "personal nix configuration";
    stateVersion = mkOption {
      type = types.str;
      default = "25.11";
      description = "NixOS state version";
    };
  };

  config = mkIf config.personal.nix-config.enable {
    system.stateVersion = config.personal.nix-config.stateVersion;

    nix = let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in {
      settings = {
        experimental-features = "nix-command flakes";
        flake-registry = "";
        nix-path = config.nix.nixPath;
      };
      channel.enable = false;
      registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };
  };
}
