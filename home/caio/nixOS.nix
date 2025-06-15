{
  imports = [ ../common ../features/cli ../features/desktop ./home.nix ];

  features = {
    cli = {
      zsh.enable = true;
      neofetch.enable = true;
      starship.enable = true;
      qt.enable = false;
      lsp.enable = true;
    };
    desktop = {
      hyprland.enable = true;
      wayland.enable = true;
      fonts.enable = true;
      rofi.enable = true;
      thunar.enable = true;
      rpi_imager.enable = true;
      latex.enable = true;
    };
  };
}
