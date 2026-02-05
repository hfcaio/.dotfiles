{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cli.fetch;
in {
  options.features.cli.fetch.enable = mkEnableOption "enable system fetch";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [fastfetch];
  };
}
