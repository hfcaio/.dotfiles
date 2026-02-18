{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.thunar;
in {
  options.features.desktop.thunar.enable =
    mkEnableOption "install thunar file manager";

  config = mkIf cfg.enable { home.packages = with pkgs; [ thunar ]; };

}
