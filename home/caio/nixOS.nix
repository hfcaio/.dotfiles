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
			yazi.enable = true;
    };
    desktop = {
      hyprland.enable = true;
      fonts.enable = true;
      rofi.enable = true;
      thunar.enable = false;
      rpi_imager.enable = true;
      latex.enable = false;
      ipscan.enable = true;
      gcs.enable = true;
      arduino.enable = true;
    };
  };
}
