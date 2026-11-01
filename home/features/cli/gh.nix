{ pkgs, config, lib, ... }:
with lib;
let cfg = config.features.cli.gh;
in {
  options.features.cli.gh.enable = mkEnableOption "enable GitHub CLI";

  config = mkIf cfg.enable {
    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
  };
}
