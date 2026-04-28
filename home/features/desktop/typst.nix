{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.typst;
in
{
  options.features.desktop.typst.enable = mkEnableOption "install texlive and latex usefull packages";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      typst
      zathura
      typstPackages.zap
      typstPackages.fletcher
    ];
  };
}
