{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.nautilus;
in {
  options.features.desktop.nautilus.enable =
    mkEnableOption "install nautilus file manager";

  config = mkIf cfg.enable { home.packages = with pkgs; [ nautilus ]; };

}
