{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.ipscan;
in {
  options.features.desktop.ipscan.enable =
    mkEnableOption "install angry ip scanner";

  config = mkIf cfg.enable { home.packages = with pkgs; [ angryipscanner ]; };
}
