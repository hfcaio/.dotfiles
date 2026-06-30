{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.obs;
in {
  options.features.desktop.obs.enable =
    mkEnableOption "install OBS Studio";

  config = mkIf cfg.enable {
    programs.obs-studio.enable = true;
  };
}
