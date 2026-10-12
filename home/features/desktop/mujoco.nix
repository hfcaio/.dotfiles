{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.mujoco;
in {
  options.features.desktop.mujoco.enable =
    mkEnableOption "install mujoco file manager";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ mujoco ];

    xdg.desktopEntries.mujoco = {
      name = "MuJoCo Simulate";
      exec = "${pkgs.mujoco}/bin/simulate";
      comment = "MuJoCo physics simulator";
      categories = [ "Science" "Simulation" ];
    };
  };

}
