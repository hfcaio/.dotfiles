{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.vagrant;
in {
  options.features.desktop.vagrant.enable =
    mkEnableOption "install Vagrant";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ vagrant ];
  };
}
