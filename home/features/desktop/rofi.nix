{
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.features.desktop.rofi;
in
{
  options.features.desktop.rofi.enable = mkEnableOption "enable rofi";

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;

      extraConfig = {
        modi = "drun,run,window";
        show-icons = true;
        drun-display-format = "{name}";
        font = "JetBrains Mono 12";
        icon-theme = "Papirus";
      };

      theme =
        let
          inherit (config.lib.formats.rasi) mkLiteral;
        in
        {
          "*" = {
            border = mkLiteral "0";
            margin = mkLiteral "0";
            padding = mkLiteral "0";
          };

          "window" = {
            width = mkLiteral "600px";
            border-radius = mkLiteral "12px";
            border = mkLiteral "2px solid";
            background-color = lib.mkForce (mkLiteral "rgba(0,0,0,0.3)"); # translucent
          };

          "mainbox" = {
            padding = mkLiteral "12px";
            spacing = mkLiteral "8px";
            background-color = mkLiteral "transparent";
          };

          "listview" = {
            background-color = mkLiteral "transparent";
            padding = mkLiteral "0 4px";
            spacing = mkLiteral "2px";
          };

          "element" = {
            border-radius = mkLiteral "8px";
            padding = mkLiteral "8px 12px";
            background-color = mkLiteral "transparent";
          };

          "element-icon" = {
            size = mkLiteral "24px";
          };
        };
    };
  };
}
