{ config, lib, ... }:
with lib;
let cfg = config.features.cli.zsh;
in {
  options.features.cli.zsh.enable =
    mkEnableOption "enable extended zsh configuration";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      dotDir = "~/.config/zsh";
      syntaxHighlighting.enable = true;
      oh-my-zsh.enable = true;
      oh-my-zsh.plugins = [ "git" "z" ];
    };
  };
}
