{ pkgs, config, lib, ... }:
with lib;
let cfg = config.features.cli.direnv;
in {
  options.features.cli.direnv.enable = mkEnableOption "enable direnv support";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ direnv ];

    home.file.".direnvrc".text = ''
      eval "$(direnv hook bash)"
    '';
  };

}
