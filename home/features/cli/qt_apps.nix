{ pkgs, config, lib, ... }:
with lib;
let cfg = config.features.cli.qt;
in {
  options.features.cli.qt.enable =
    mkEnableOption "download qt dependencies packages";

  config =
    mkIf cfg.enable { home.packages = with pkgs; [ qt5.full qtcreator ]; };
}
