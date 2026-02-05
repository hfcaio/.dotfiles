{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cli.fzf;
in {
  options.features.cli.fzf.enable = mkEnableOption "enable fuzzy finder";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [fzf];
  };
}
