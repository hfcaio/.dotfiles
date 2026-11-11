{ pkgs, config, ... }:
{
  home.username = "caio-freitas";
  home.homeDirectory = "/home/caio-freitas";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  fonts.fontconfig.enable = true;

  # Exporta ~/.nix-profile/share pra sessao grafica (environment.d), senao o
  # GNOME nao enxerga os .desktop/icones instalados pelo home-manager.
  xdg.systemDirs.data = [ "${config.home.profileDirectory}/share" ];

  home.file = {
    ".clang-format".source = ../features/cli/formatters/.clang-format;
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs.zsh.initExtra = ''
    [ -f /opt/ros/jazzy/setup.zsh ] && source /opt/ros/jazzy/setup.zsh
    command -v micromamba >/dev/null && eval "$(micromamba shell hook -s zsh)"
  '';

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
