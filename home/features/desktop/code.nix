{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.code;
in {
  options.features.desktop.code.enable =
    mkEnableOption "install vscode and extensions";

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      profiles.default.userSettings = {
        "workbench.settings.editor" = "json";
        "workbench.editor.defaultBinaryEditor" = "default";
        "editor.tabSize" = 4;
        "workbench.iconTheme" = "material-icon-theme";
        "editor.formatOnSave" = true;
      };
    };
  };
}
