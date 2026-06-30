{ config, lib, ... }:
with lib;
let 
	cfg = config.features.cli.zsh;
	scripts_dir = "/home/caio/git_projects/.dotfiles/scripts";
in {
  options.features.cli.zsh.enable =
    mkEnableOption "enable extended zsh configuration";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      shellAliases = {
				blt = "${scripts_dir}/blt";
				nrs = "sudo nixos-rebuild switch --flake .";
				nfu = "nix flake update && sudo nixos-rebuild switch --flake .";
        matlab =
          "docker start matlab && docker exec -it matlab /usr/local/MATLAB/R2025b/bin/matlab -nodisplay -nosplash -nodesktop";
      };
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      oh-my-zsh.enable = true;
      oh-my-zsh.plugins = [ "git" "z" ];
    };
  };
}
