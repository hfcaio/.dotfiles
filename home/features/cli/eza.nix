{ config, lib, ... }:
with lib;
let cfg = config.features.cli.eza;
in {
  options.features.cli.eza.enable =
    mkEnableOption "eza (ls replacement) with icons";

  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      icons = "auto";
      git = true;
      enableZshIntegration = true; # ls, ll, la, lt, lla aliases
      extraOptions = [ "--group-directories-first" ];
    };
  };
}
