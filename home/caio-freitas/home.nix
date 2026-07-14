{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  home.username = "caio-freitas";
  home.homeDirectory = "/home/caio-freitas";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    nerd-fonts.fira-code
    inputs.zen-browser.packages."${pkgs.system}".default
  ];

  home.file = {
    ".clang-format".source = ../features/cli/formatters/.clang-format;
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-family = "FiraCode Nerd Font Mono";
      font-size = 12;
      background-opacity = 0.85;
      background-blur-radius = 10;
      gtk-opengl-fallback = true;
      keybind = [
        "ctrl+b>c=new_tab"
        "ctrl+b>n=next_tab"
        "ctrl+b>p=previous_tab"
        "ctrl+b>x=close_surface"
        "ctrl+b>shift+five=new_split:right"
        "ctrl+b>shift+apostrophe=new_split:down"
        "ctrl+b>left=goto_split:left"
        "ctrl+b>right=goto_split:right"
        "ctrl+b>up=goto_split:up"
        "ctrl+b>down=goto_split:down"
        "ctrl+b>z=toggle_split_zoom"
      ];
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
