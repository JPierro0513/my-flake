{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; {
  options.personal.editor = {
    enable = mkEnableOption "editor configuration";

    neovim = {
      enable = mkEnableOption "Neovim configuration";
      useNightly = mkOption {
        type = types.bool;
        default = true;
        description = "Use neovim nightly build";
      };
      defaultEditor = mkOption {
        type = types.bool;
        default = true;
        description = "Set neovim as default editor";
      };
    };

    zed = {
      enable = mkEnableOption "Zed editor";
      fhs = {
        enable = mkEnableOption "Zed editor FHS";
      };
    };
  };

  config = mkIf config.personal.editor.enable {
    environment.systemPackages = with pkgs;
      optionals config.personal.editor.zed [
        zed-editor
      ]
      ++ optionals config.personal.editor.zed.fhs [
        zed-editor-fhs
      ];

    programs.neovim = mkIf config.personal.editor.neovim.enable {
      enable = true;
      defaultEditor = config.personal.editor.neovim.defaultEditor;
      package =
        if config.personal.editor.neovim.useNightly && inputs ? neovim-nightly
        then inputs.neovim-nightly.packages.${pkgs.system}.default
        else pkgs.neovim;
    };
  };
}
