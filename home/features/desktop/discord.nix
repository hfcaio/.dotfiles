{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.discord;
in {
  options.features.desktop.discord.enable =
    mkEnableOption "install discord";

  config = mkIf cfg.enable { home.packages = with pkgs; [ discord]; };
}
