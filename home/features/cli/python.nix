{ pkgs, config, lib, ... }:
with lib;
let cfg = config.features.cli.python;
in {
  options.features.cli.python = {
    enable = mkEnableOption "Enable Python CLI tools and environment";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      python313
      python313Packages.pip
      python313Packages.setuptools
      python313Packages.virtualenv
    ];
  };
}
