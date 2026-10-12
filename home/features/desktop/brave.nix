{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.brave;
in {
  options.features.desktop.brave.enable =
    mkEnableOption "install brave browser";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ brave ];
  };
}
