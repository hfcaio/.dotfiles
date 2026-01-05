{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.gcs;
in {
  options.features.desktop.gcs.enable = mkEnableOption "install QGroundcontrol";

  config = mkIf cfg.enable { home.packages = with pkgs; [ qgroundcontrol ]; };
}

