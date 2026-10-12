# Shell FHS a partir do qual se roda o instalador da MathWorks (`./install`).
#
# Usa exatamente as mesmas dependências do wrapper `matlab`, mas não exige que o MATLAB já
# esteja instalado — é o ovo antes da galinha.
{ lib, buildFHSEnv }:

buildFHSEnv {
  name = "matlab-shell";

  targetPkgs = import ./deps.nix;

  profile = ''
    export QT_QPA_PLATFORM=xcb
    export _JAVA_AWT_WM_NONREPARENTING=1
    cat <<'EOF'
    ============================================================
    matlab-shell — ambiente FHS para instalar o MATLAB.

      1. cd para a pasta do instalador extraído
      2. ./install
      3. escolha um destino GRAVÁVEL, igual ao installDir do módulo
         (padrão: ~/.local/share/MATLAB/R2025b)
      4. exit
    ============================================================
EOF
  '';

  runScript = "bash";

  meta = {
    description = "Shell FHS para instalar o MATLAB ou rodá-lo pela CLI";
    homepage = "https://www.mathworks.com/";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
