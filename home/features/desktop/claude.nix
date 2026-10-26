{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.claude;
in
{
  options.features.desktop.claude.enable =
    mkEnableOption "install Claude Desktop (Electron app, from the official Anthropic .deb)";

  config = mkIf cfg.enable {
    home.packages = [ pkgs.claude-desktop ];
  };
}
