{
  lib,
  config,
  pkgs,
  ...
}:
with lib; {
  options.personal.shell = {
    enable = mkEnableOption "fish shell configuration";

    defaultShell = mkOption {
      type = types.package;
      default = pkgs.fish;
      description = "Default shell for users";
    };

    theme = {
      symbol = mkOption {
        type = types.str;
        default = "❯";
        description = "Shell prompt symbol";
      };

      colors = {
        pwd = mkOption {
          type = types.str;
          default = "cyan";
          description = "Color for current directory";
        };
        git = mkOption {
          type = types.str;
          default = "purple";
          description = "Color for git status";
        };
        prompt = mkOption {
          type = types.str;
          default = "green";
          description = "Color for prompt symbol";
        };
        error = mkOption {
          type = types.str;
          default = "red";
          description = "Color for error messages";
        };
        duration = mkOption {
          type = types.str;
          default = "yellow";
          description = "Color for command duration";
        };
      };
    };

    aliases = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Additional shell aliases";
    };
  };

  config = mkIf config.personal.shell.enable {
    users.defaultUserShell = config.personal.shell.defaultShell;

    environment.systemPackages = with pkgs;
      [
        done
        grc
        fd
        ripgrep
        eza
        bat
        fzf
        zoxide
      ]
      ++ (with pkgs.fishPlugins; [
        done
        grc
        hydro
        forgit
        pisces
        transient-fish
      ]);

    programs.fish = {
      enable = true;
      interactiveShellInit = with config.personal.shell.theme; ''
        set fish_greeting false

        set hydro_multiline true

        set hydro_color_pwd ${colors.pwd}
        set hydro_color_git ${colors.git}
        set hydro_color_prompt ${colors.prompt}
        set hydro_color_error ${colors.error}
        set hydro_color_duration ${colors.duration}

        set hydro_symbol_prompt "${symbol}"

        set fish_prompt_pwd_dir_length 10

        zoxide init --cmd cd fish | source
      '';
      shellAliases =
        {
          "ls" = "eza -1 --group-directories-first --icons";
          "la" = "ls -a";
          "ll" = "ls -l";
          "l" = "ls -al";
          "cat" = "bat";
          "rebuild" = "sudo nixos-rebuild switch";
        }
        // config.personal.shell.aliases;
    };
  };
}
