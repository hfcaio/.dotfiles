{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.features.desktop.claude;
  dotfiles = ../../../.claude;
in {
  options.features.desktop.claude = {
    enable = mkEnableOption "install Claude Code CLI";
    desktop.enable = mkEnableOption "install Claude Desktop (Electron app, from the official Anthropic .deb)";
    settings.enable = mkEnableOption "manage ~/.claude/CLAUDE.md and settings.json from this repo";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [ pkgs.claude-code ];
    })
    (mkIf cfg.desktop.enable {
      home.packages = [ pkgs.claude-desktop ];
    })
    (mkIf cfg.settings.enable {
      # Symlink the versioned files from .dotfiles/.claude/ into ~/.claude/.
      # home-manager fails if the target already exists as a non-symlink —
      # back up or delete ~/.claude/CLAUDE.md and ~/.claude/settings.json before
      # the first `home-manager switch` after enabling this.
      home.file.".claude/CLAUDE.md".source = dotfiles + "/CLAUDE.md";
      home.file.".claude/settings.json".source = dotfiles + "/settings.json";
    })
  ];
}
