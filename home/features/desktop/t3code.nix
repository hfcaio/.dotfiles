{ pkgs, config, lib, ... }:
with lib;
let cfg = config.features.desktop.t3code;
in {
  options.features.desktop.t3code.enable = mkEnableOption "enable t3code support";

  config = mkIf cfg.enable {
    programs.t3code = {
      enable = true;
      package = pkgs.unstable.t3code;
    };
  };
}
