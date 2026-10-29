{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.features.desktop.t3code;

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
    '';
  };
in {
  options.features.desktop.t3code.enable = mkEnableOption "enable t3code support";

  config = mkIf cfg.enable {
    programs.t3code = {
      enable = true;
      package = t3code;
    };
  };
}
