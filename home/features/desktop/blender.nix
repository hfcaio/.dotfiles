{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.blender;
in {
  options.features.desktop.blender.enable =
    mkEnableOption "install blender";

  config = mkIf cfg.enable {
  	home.packages = with pkgs; [blender];
  };
}
