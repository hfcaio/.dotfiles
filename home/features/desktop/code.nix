{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.code;
in {
  options.features.desktop.code.enable =
    mkEnableOption "install vscode and extensions";

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      extensions = with pkgs; [
        vscode-extensions.catppuccin.catppuccin-vsc
        vscode-extensions.vscodevim.vim
      ];

    };
  };
}
