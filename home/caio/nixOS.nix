{
  imports = [
    ../common
    ../features/cli
    ../features/desktop
    ./home.nix
  ];

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
    };
    desktop = {
      hyprland.enable = true;
      wayland.enable = true;
      fonts.enable = true;
      rofi.enable = true;
      thunar.enable = true;
      rpi_imager.enable = true;
      latex.enable = true;
      ipscan.enable = true;
      gcs.enable = true;
      arduino.enable = true;
    };
  };
}
