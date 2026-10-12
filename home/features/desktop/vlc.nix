{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.vlc;
in {
  options.features.desktop.vlc.enable =
    mkEnableOption "install vlc media player";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ vlc ];
  };
}
