{ pkgs, ... }:
{

  imports = [
    ../common
    ../features/cli
    ../features/desktop
    ./home.nix
    ./ssh.nix
  ];

  stylix = {
    enable = true;
    image = ../features/desktop/images/117794241_p2.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    targets.waybar.enable = false;
    targets.hyprland = {
      enable = true;
      image.enable = true;
    };
    opacity = {
      applications = 0.8;
      desktop = 0.8;
      terminal = 0.5;
    };
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Mono";
      };
      sizes.terminal = 12;
    };
  };

  features = {
    cli = {
      zsh.enable = true;
      fetch.enable = true;
      starship.enable = true;
      lsp.enable = true;
      nvim.enable = true;
      python.enable = true;
      fzf.enable = true;
      direnv.enable = true;
      yazi.enable = false;
    };
    desktop = {
      hyprland.enable = true;
      fonts.enable = true;
      blender.enable = true;
      rofi.enable = true;
      rofi-powermenu.enable = true;
      thunar.enable = false;
      nautilus.enable = true;
      rpi_imager.enable = true;
      latex.enable = false;
      ipscan.enable = true;
      gcs.enable = true;
      arduino.enable = true;
      discord.enable = true;
    };
  };
}
