{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.rofi;
in {
  options.features.desktop.rofi.enable =
    mkEnableOption "install additional rofi for desktop apps";

  config = mkIf cfg.enable { home.packages = with pkgs; [ rofi-wayland ]; };
}
