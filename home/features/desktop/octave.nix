{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.octave;
in {
  options.features.desktop.octave.enable =
    mkEnableOption "install octave";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (octave.withPackages (ps: [ ps.control ]))
    ];
  };
}
