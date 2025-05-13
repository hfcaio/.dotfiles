{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.rpi_imager;
in {
  options.features.desktop.rpi_imager.enable =
    mkEnableOption "install rpi_imager file manager";

  config = mkIf cfg.enable { home.packages = with pkgs; [ rpi-imager ]; };

}
