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
      userSettings = {
        "workbench.settings.editor" = "json";
        "workbench.editor.defaultBinaryEditor" = "default";
        "editor.tabSize" = 2;
        "editor.fontFamily" = "'Fira Code'";
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "material-icon-theme";
        "editor.formatOnSave" = true;
      };
    };
  };
}
