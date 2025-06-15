{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.latex;
in {
  options.features.desktop.latex.enable =
    mkEnableOption "install texlive and latex packages";

  config = mkIf cfg.enable { home.packages = with pkgs; [ texliveFull ]; };
}
