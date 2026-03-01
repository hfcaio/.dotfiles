{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cli.yazi;
in {
  options.features.cli.yazi.enable = mkEnableOption "enable yazi file manager";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [yazi];
  };
}
