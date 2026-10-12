{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.matlab;
in {
  options.features.desktop.matlab = {
    enable = mkEnableOption "MATLAB (wrapper FHS sobre instalação imperativa)";

    installDir = mkOption {
      type = types.str;
      default = "${config.home.homeDirectory}/.local/share/MATLAB/R2025b";
      description = ''
        Diretório onde o instalador da MathWorks colocou o MATLAB. Fica fora da nix store
        porque a instalação é imperativa (login, download de dezenas de GB e ativação de
        licença). Rode `matlab-shell` e depois `./install` para criá-lo.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ matlab matlab-shell ];

    # Lido em runtime pelo wrapper em pkgs/matlab/default.nix
    xdg.configFile."matlab/nix.sh".text = ''
      INSTALL_DIR=${cfg.installDir}
    '';

    xdg.desktopEntries.matlab = {
      name = "MATLAB";
      # -desktop é necessário quando o MATLAB é lançado fora de um terminal
      exec = "${pkgs.matlab}/bin/matlab -desktop %F";
      icon = "matlab";
      comment = "MATLAB R2025b";
      categories = [ "Development" "Science" "IDE" ];
      mimeType = [ "text/x-matlab" ];
    };
  };
}
