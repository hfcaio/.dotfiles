{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.features.desktop.rofi-wifi;
in
{
  options.features.desktop.rofi-wifi.enable = mkEnableOption "enable rofi wifi menu";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      libnotify
    ];

    home.file.".config/rofi/wifi.sh".source =
      pkgs.writeShellScript "rofi-wifi" (builtins.readFile ./rofi/scripts/wifi.sh);
  };
}
