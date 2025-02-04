{ config, lib, ... }:
with lib;
let cfg = config.features.cli.starship;
in {
  options.features.cli.starship.enable =
    mkEnableOption "enable starship";

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        character = {
          success_symbol = "[>](bold green)";
          error_symbol = "[>](bold red)";
        };
        git_branch = {
          symbol = " ";
          style = "bright-white";
        };
      };
    };
  };
}
