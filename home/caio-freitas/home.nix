{ pkgs, ... }:
{
  home.username = "caio-freitas";
  home.homeDirectory = "/home/caio-freitas";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  fonts.fontconfig.enable = true;

  home.file = {
    ".clang-format".source = ../features/cli/formatters/.clang-format;
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs.zsh.initExtra = ''
    [ -f /opt/ros/jazzy/setup.zsh ] && source /opt/ros/jazzy/setup.zsh
  '';

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
