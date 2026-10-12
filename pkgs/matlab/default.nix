# MATLAB — wrapper FHS.
#
# O MATLAB em si NÃO está aqui: o instalador da MathWorks exige login, baixa dezenas de GB e
# ativa licença, nada disso é reproduzível. Este pacote só monta o ambiente FHS em que os
# binários pré-compilados da MathWorks conseguem rodar, e executa a instalação imperativa
# apontada por $INSTALL_DIR.
#
# $INSTALL_DIR é lido em runtime de ~/.config/matlab/nix.sh (gerado pelo módulo home-manager
# em home/features/desktop/matlab.nix), e não embutido na store — assim mudar o caminho da
# instalação não exige rebuild.
#
# Ver: https://wiki.nixos.org/wiki/Matlab e https://gitlab.com/doronbehar/nix-matlab
{ lib, buildFHSEnv, writeShellScript }:

buildFHSEnv {
  name = "matlab";

  targetPkgs = import ./deps.nix;

  runScript = writeShellScript "matlab-runner" ''
    # Necessário mesmo em sistemas Wayland (Simulink)
    export QT_QPA_PLATFORM=xcb
    # Sem isto a IDE (Java/AWT) abre em branco sob WMs não-reparenting como o Hyprland
    export _JAVA_AWT_WM_NONREPARENTING=1
    # A IDE é Java/AWT, que fala XIM. Passando pelo fcitx5 o layout vira o dele (us por
    # padrão) em vez do do servidor X, e teclas somem. Sem input method o AWT lê o XKB
    # direto — o layout br resolve acentos e ç nativamente, sem precisar de IM.
    export XMODIFIERS=@im=none
    unset GTK_IM_MODULE QT_IM_MODULE

    nix_sh="''${XDG_CONFIG_HOME:-$HOME/.config}/matlab/nix.sh"
    if [[ -f "$nix_sh" ]]; then
      source "$nix_sh"
    else
      echo "matlab: falta $nix_sh (defina INSTALL_DIR=... ou ligue features.desktop.matlab)" >&2
      exit 1
    fi
    if [[ ! -d "$INSTALL_DIR" ]]; then
      echo "matlab: INSTALL_DIR '$INSTALL_DIR' não é um diretório — o MATLAB já foi instalado?" >&2
      exit 2
    fi

    # LD_PRELOAD força o libstdc++ do nixpkgs sobre o que a MathWorks embute em
    # $INSTALL_DIR/sys/os/glnxa64 — a versão deles é velha demais para as libs do FHS e quebra
    # o OpenGL por hardware.
    exec env \
      LD_PRELOAD=/lib/libstdc++.so \
      LD_LIBRARY_PATH=/usr/lib/xorg/modules/dri/ \
      "$INSTALL_DIR/bin/matlab" "$@"
  '';

  meta = {
    description = "MATLAB - wrapper FHS para uma instalação imperativa";
    homepage = "https://www.mathworks.com/";
    # Licença deste wrapper, não do MATLAB
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "matlab";
  };
}
