{ pkgs, config, lib, ... }:
with lib;
let cfg = config.features.cli.ssh;
in {
  options.features.cli.ssh.enable =
    mkEnableOption "set config for ssh and sshd";

  config =
    mkIf cfg.enable { 
      programs.ssh ={
        enable = true; 
        extraConfig = ''
          Host pi
            HostName 172.20.10.2
            User skyrats
        '';
    };
}