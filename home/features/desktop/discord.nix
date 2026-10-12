{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.desktop.discord;
in {
  options.features.desktop.discord.enable =
    mkEnableOption "install discord";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ discord ];

    # Discord gera symlinks em ~/.config/discord/<ver>/modules/ apontando pro store path
    # do pacote na primeira execução. Quando nix-collect-garbage apaga esse store path (p.ex.
    # após qualquer rebuild que mude o derivation), os symlinks ficam dangling e o launcher
    # morre com "Cannot find module 'discord_desktop_core'". Remover o diretório da versão
    # faz o Discord recriar os symlinks na próxima execução. Prefs/cookies ficam direto em
    # ~/.config/discord/ (fora de <ver>/) então não se perde nada.
    home.activation.pruneStaleDiscordModules = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      shopt -s nullglob
      for dir in "$HOME/.config/discord"/*/; do
        sym="$dir/modules/discord_desktop_core"
        if [ -L "$sym" ] && ! [ -e "$sym" ]; then
          run ${pkgs.coreutils}/bin/rm -rf "$dir"
          echo "discord: pruned stale version dir $dir (symlink -> GC'd store path)"
        fi
      done
    '';
  };
}
