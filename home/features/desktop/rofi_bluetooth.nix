{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.features.desktop.rofi-bluetooth;
in
{
  options.features.desktop.rofi-bluetooth.enable = mkEnableOption "enable rofi bluetooth menu";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      libnotify
    ];

    home.file.".config/rofi/bluetooth.sh".source =
      pkgs.writeShellScript "rofi-bluetooth" (builtins.readFile ./rofi/scripts/bluetooth.sh);
  };
}
