{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.quickshell;
in {
  options.features.desktop.quickshell.enable = mkEnableOption "enable quickshell";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [quickshell];
  };
}
