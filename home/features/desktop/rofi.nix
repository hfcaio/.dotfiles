{ config, lib, pkgs, ... }:

with lib;
let cfg = config.features.desktop.rofi;
in {
  options.features.desktop.rofi.enable = mkEnableOption "enable rofi";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.rofi ];

    programs.rofi = { enable = true; };
  };
}
