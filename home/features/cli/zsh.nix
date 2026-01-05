{ config, lib, ... }:
with lib;
let cfg = config.features.cli.zsh;
in {
  options.features.cli.zsh.enable =
    mkEnableOption "enable extended zsh configuration";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      shellAliases = {
        matlab =
          "docker start matlab && docker exec -it matlab /usr/local/MATLAB/R2025b/bin/matlab -nodisplay -nosplash -nodesktop";
      };
      dotDir = "~/.config/zsh";
      syntaxHighlighting.enable = true;
      oh-my-zsh.enable = true;
      oh-my-zsh.plugins = [ "git" "z" ];
    };
  };
}
