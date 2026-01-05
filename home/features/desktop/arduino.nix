{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.arduino;
in {
  options.features.desktop.arduino.enable =
    mkEnableOption "install arduino IDE and dependencies";

  config = mkIf cfg.enable { home.packages = with pkgs; [ arduino-ide ]; };
}
