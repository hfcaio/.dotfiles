{ pkgs, config, lib, ... }:
with lib;
let cfg = config.features.cli.opencode;
in {
  options.features.cli.opencode.enable = mkEnableOption "enable opencode support";

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      package = pkgs.unstable.opencode;
      web.enable = true;
    };
  };
}
