{ config, pkgs, ... }:


{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "caio";
  home.homeDirectory = "/home/caio";
  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
avrdude
    waybar
    alacritty
    fira-code-nerdfont
    angryipscanner
    octaveFull
    arduino
    quartus-prime-lite
    gtkwave
    ghdl
    discord
    eagle
obs-studio  
hyprshot
hypridle
hyprlock
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/caio/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = { EDITOR = "neovim"; };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


  # configure waybar
  programs.waybar = {
    enable = true;
    style = ./waybar.css;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "custom/logo" "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "light" "pulseaudio" "network" "battery" ];

        battery = {
          format = "{capacity}% {icon}";
          "format-icons" = {
            "charging" = [ "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅" ];
            "default" = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          };
          "format-full" = "󰁹 ";
          interval = 1;
          states = {
            warning = 20;
            critical = 10;
          };
          tooltip = false;
        };

        light = {
          format = "{brightness}% {icon}";
        };
        
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr}";
          tooltip-format = "{ifname} via {gwaddr}";
          format-linked = "{ifname} (No IP)";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "󰂰";
          nospacing = 1;
          tooltip-format = "Volume : {volume}%";
          format-muted = "󰝟";
          format-icons = {
            headphone = "";
            default = [ "󰖀" "󰕾" "" ];
          };
          on-click = "pamixer -t";
          scroll-step = 1;
        };

        clock = {
          "tooltip-format" = "<tt>{calendar}</tt>";
          "format-alt" = "  {:%a, %d %b %Y}";
          format = "󰥔  {:%I:%M %p}";
        };

        "custom/logo" = {
          format = "  ";
          tooltip = false;
        };
      };
    };
  };

  # configure zsh
  programs.zsh = {
    enable = true;
    #autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh.enable = true;
    oh-my-zsh.plugins = [ "git" "z" ];
    oh-my-zsh.theme = "bira";
  };

  #configure alacritty 
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    window.opacity = 0.5;

  };
}
