{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.ros2;
  humble = pkgs.ros2.humble;

  envArgs = {
    inherit (cfg) domainId;
    cycloneddsUri = if cfg.cycloneddsLoopback then humble.cycloneddsLoopbackUri else null;
  };
  rosEnv = if cfg.gui then humble.guiBuildEnv envArgs else humble.buildEnv envArgs;
in
{
  options.features.desktop.ros2 = {
    enable = mkEnableOption "install ROS 2 Humble (built from source) and colcon";
    gui = mkEnableOption "rviz2 and rqt in the ROS 2 environment (bigger build)";
    domainId = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "Default ROS_DOMAIN_ID exported by setup.zsh (an already-set variable wins). null: leave unset.";
    };
    cycloneddsLoopback = mkEnableOption "CycloneDDS over loopback with multicast + localhost peer (what the unitree_mujoco simulator needs); an already-set CYCLONEDDS_URI wins";
  };

  config = mkIf cfg.enable {
    home.packages = [
      rosEnv
      (lib.lowPrio humble.colcon) # its python env would clash with other python3 envs
    ];

    # same as `source /opt/ros/humble/setup.zsh`
    programs.zsh.initContent = ''
      source ${rosEnv}/setup.zsh
    '';
  };
}
