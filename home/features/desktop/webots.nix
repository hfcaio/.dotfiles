{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.webots;
in {
  options.features.desktop.webots.enable =
    mkEnableOption "Webots robot simulator (FHS-wrapped)";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ webots-fhs ];

    xdg.desktopEntries.webots = {
      name = "Webots";
      exec = "${pkgs.webots-fhs}/bin/webots";
      icon = "webots";
      comment = "Webots robot simulator";
      categories = [ "Development" "Science" "Education" ];
    };
  };
}
