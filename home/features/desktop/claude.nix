{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.claude;
in {
  options.features.desktop.claude.enable =
    mkEnableOption "install Claude Code CLI";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ claude-code ];
  };
}
