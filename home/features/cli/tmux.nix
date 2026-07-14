{ config, lib, ... }:
with lib;
let cfg = config.features.cli.tmux;
in {
  options.features.cli.tmux.enable = mkEnableOption "tmux config";

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      prefix = "C-b";
      mouse = true;
      keyMode = "vi";
      terminal = "tmux-256color";
      extraConfig = ''
        set -ag terminal-overrides ",xterm-256color:RGB"

        set -g base-index 1
        setw -g pane-base-index 1
        set -g renumber-windows on

        # Split panes
        bind % split-window -h -c "#{pane_current_path}"
        bind '"' split-window -v -c "#{pane_current_path}"

        # Navigate panes with hjkl
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # Resize panes
        bind -r H resize-pane -L 5
        bind -r J resize-pane -D 5
        bind -r K resize-pane -U 5
        bind -r L resize-pane -R 5

        # Reload config
        bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
      '';
    };
  };
}
