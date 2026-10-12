{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.features.desktop.rofi-powermenu;
in
{
  options.features.desktop.rofi-powermenu.enable = mkEnableOption "enable rofi powermenu";

  config = mkIf cfg.enable {
    home.file.".config/rofi/powermenu.rasi".source = ./rofi/themes/powermenu.rasi;

    home.file.".config/rofi/powermenu.sh".source =
      pkgs.writeShellScript "powermenu" (builtins.readFile ./rofi/scripts/powermenu.sh);
  };
}
