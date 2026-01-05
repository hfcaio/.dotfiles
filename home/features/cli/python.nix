{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.features.cli.python;

  myPython = pkgs.python313.withPackages (ps:
    with ps; [
      pip
      setuptools
      virtualenv
      jupyterlab # interface moderna
      notebook # ainda útil em alguns casos
      ipykernel
      numpy
      matplotlib
      cvxpy
      opencv4 # opcional
    ]);
in {
  options.features.cli.python = {
    enable = mkEnableOption "Enable Python CLI tools and environment";
  };

  config = mkIf cfg.enable { home.packages = [ myPython ]; };
}
