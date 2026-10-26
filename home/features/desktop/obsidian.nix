{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.obsidian;
in {
  options.features.desktop.obsidian.enable =
    mkEnableOption "install obsidian markdown knowledge base";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ obsidian ];
  };
}
