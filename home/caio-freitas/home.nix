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
  ];

  fonts.fontconfig.enable = true;

  home.file = {
    ".clang-format".source = ../features/cli/formatters/.clang-format;
  };

  xdg.dataFile = {
    "applications/com.mitchellh.ghostty.desktop".text = ''
      [Desktop Entry]
      Version=1.0
      Name=Ghostty
      Type=Application
      Comment=A terminal emulator
      TryExec=${config.home.homeDirectory}/.nix-profile/bin/ghostty
      Exec=${config.home.homeDirectory}/.nix-profile/bin/ghostty --gtk-single-instance=true
      Icon=com.mitchellh.ghostty
      Categories=System;TerminalEmulator;
      Keywords=terminal;tty;pty;
      StartupNotify=true
      StartupWMClass=com.mitchellh.ghostty
      Terminal=false
      Actions=new-window;
      X-TerminalArgExec=-e

      [Desktop Action new-window]
      Name=New Window
      Exec=${config.home.homeDirectory}/.nix-profile/bin/ghostty --gtk-single-instance=true
    '';
    "icons/hicolor" = {
      source = "${pkgs.ghostty}/share/icons/hicolor";
      recursive = true;
    };
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs.symlinkJoin {
      name = "ghostty-nixgl";
      paths = [ pkgs.ghostty ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        rm $out/bin/ghostty
        makeWrapper ${inputs.nixgl.packages."${pkgs.system}".nixGLIntel}/bin/nixGLIntel $out/bin/ghostty \
          --add-flags "${pkgs.ghostty}/bin/ghostty"
      '';
    };
    settings = {
      font-family = "FiraCode Nerd Font Mono";
      font-size = 12;
      background-opacity = 0.85;
      background-blur-radius = 10;
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
