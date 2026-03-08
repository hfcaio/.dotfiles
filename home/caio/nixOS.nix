
{pkgs, ...}:
{

  imports = [
    ../common
    ../features/cli
    ../features/desktop
    ./home.nix
  ];

  stylix = {
    enable = true;
    image = ../features/desktop/images/117794241_p2.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    targets.waybar.enable = false;
    targets.kitty.enable = false;
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
      rofi.enable = true;
      rofi-powermenu.enable = true;
      thunar.enable = false;
			nautilus.enable = true;
      rpi_imager.enable = true;
      latex.enable = false;
      ipscan.enable = true;
      gcs.enable = true;
      arduino.enable = true;
    };
  };
}
