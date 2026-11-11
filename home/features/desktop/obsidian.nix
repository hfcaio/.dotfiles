{ config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.features.desktop.obsidian;

  # Fora do NixOS (Ubuntu) o Electron precisa do nixGL pra achar os drivers OpenGL.
  nixGL = "${inputs.nixgl.packages.${pkgs.stdenv.hostPlatform.system}.nixGLIntel}/bin/nixGLIntel";

  obsidian = if !cfg.nixGL then pkgs.obsidian else pkgs.symlinkJoin {
    name = "obsidian-nixgl-${pkgs.obsidian.version}";
    paths = [ pkgs.obsidian ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      rm $out/bin/obsidian
      makeWrapper ${nixGL} $out/bin/obsidian \
        --add-flags ${pkgs.obsidian}/bin/obsidian

      # Exec/Icon com caminho absoluto: a sessao grafica do Ubuntu nao tem
      # ~/.nix-profile/bin no PATH.
      rm $out/share/applications/obsidian.desktop
      sed -e "s|^Exec=obsidian|Exec=$out/bin/obsidian|" \
          -e "s|^Icon=obsidian|Icon=$out/share/icons/hicolor/512x512/apps/obsidian.png|" \
        ${pkgs.obsidian}/share/applications/obsidian.desktop \
        > $out/share/applications/obsidian.desktop
    '';
  };
in {
  options.features.desktop.obsidian = {
    enable = mkEnableOption "install obsidian markdown knowledge base";
    nixGL = mkEnableOption "wrap obsidian with nixGL (non-NixOS hosts)";
  };

  config = mkIf cfg.enable {
    home.packages = [ obsidian ];

    # O GNOME do Ubuntu sempre le ~/.local/share/applications.
    xdg.dataFile."applications/obsidian.desktop" = mkIf cfg.nixGL {
      source = "${obsidian}/share/applications/obsidian.desktop";
    };
  };
}
