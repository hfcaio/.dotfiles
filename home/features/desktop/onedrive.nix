{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.onedrive;
in {
  options.features.desktop.onedrive.enable =
    mkEnableOption "install onedrive client";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ onedrive ];
  };
}
