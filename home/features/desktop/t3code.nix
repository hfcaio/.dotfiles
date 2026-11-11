{ pkgs, config, lib, inputs, ... }:
with lib;
let
  cfg = config.features.desktop.t3code;

  # Fora do NixOS (Ubuntu) o Electron precisa do nixGL pra achar os drivers OpenGL.
  nixGL = "${inputs.nixgl.packages.${pkgs.stdenv.hostPlatform.system}.nixGLIntel}/bin/nixGLIntel";

  # O build do nixpkgs vem sem a config publica do T3 Connect; estes valores
  # sao os mesmos embutidos no AppImage oficial (nao sao segredos).
  t3code = pkgs.symlinkJoin {
    name = "t3code-connect-${pkgs.unstable.t3code.version}";
    paths = [ pkgs.unstable.t3code ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      for bin in t3 t3code-desktop; do
        rm $out/bin/$bin
        makeWrapper ${pkgs.unstable.t3code}/bin/$bin $out/bin/$bin \
          --set-default T3CODE_RELAY_URL "https://relay.t3.codes" \
          --set-default T3CODE_CLERK_PUBLISHABLE_KEY "pk_live_Y2xlcmsudDMuY29kZXMk" \
          --set-default T3CODE_CLERK_CLI_OAUTH_CLIENT_ID "hzxSgY2cH10sDU2r"
      done

      # Exec com caminho absoluto: a sessao grafica do Ubuntu nao tem ~/.nix-profile/bin no PATH.
      # O app define o app_id como com.t3tools.T3Code (setDesktopName), e o GNOME/Hyprland so
      # associam a janela ao icone se o .desktop tiver exatamente esse nome.
      rm $out/share/applications/t3code.desktop
      sed -e "s|^Exec=t3code-desktop|Exec=$out/bin/t3code-desktop|" \
          -e "s|^Icon=t3code|Icon=$out/share/icons/hicolor/1024x1024/apps/t3code.png|" \
        ${pkgs.unstable.t3code}/share/applications/t3code.desktop \
        > $out/share/applications/com.t3tools.T3Code.desktop
      echo "MimeType=x-scheme-handler/t3code;" >> $out/share/applications/com.t3tools.T3Code.desktop
    '' + optionalString cfg.nixGL ''
      mv $out/bin/t3code-desktop $out/bin/.t3code-desktop-unwrapped
      makeWrapper ${nixGL} $out/bin/t3code-desktop \
        --add-flags $out/bin/.t3code-desktop-unwrapped
    '';
  };
in {
  options.features.desktop.t3code = {
    enable = mkEnableOption "enable t3code support";
    nixGL = mkEnableOption "wrap t3code-desktop with nixGL (non-NixOS hosts)";
  };

  config = mkIf cfg.enable {
    programs.t3code = {
      enable = true;
      package = t3code;
    };

    # No Ubuntu a sessao do GNOME nao tem ~/.nix-profile/share no XDG_DATA_DIRS,
    # entao o launcher/dock nao ve o .desktop do pacote. ~/.local/share sempre e lido.
    # O app tambem reescreve esse arquivo (NoDisplay, sem icone) a cada start; como o link
    # aponta pra nix store (somente leitura) a escrita falha silenciosamente e o nosso vence.
    xdg.dataFile."applications/com.t3tools.T3Code.desktop" = mkIf cfg.nixGL {
      source = "${t3code}/share/applications/com.t3tools.T3Code.desktop";
    };
  };
}
