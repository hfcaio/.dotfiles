{ pkgs, config, lib, ... }:
with lib;
let cfg = config.features.cli.direnv;
in {
  options.features.cli.direnv.enable = mkEnableOption "enable direnv support";

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

}
