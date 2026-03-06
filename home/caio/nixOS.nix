{
	

  imports = [
    ../common
    ../features/cli
    ../features/desktop
    ./home.nix
  ];
		
	
	stylix.enable = true;
	stylix.image = ../features/desktop/images/117794241_p2.jpg;
	stylix.targets.waybar.enable = false;
	stylix.targets.kitty.enable = false;


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
      thunar.enable = true;
      rpi_imager.enable = true;
      latex.enable = false;
      ipscan.enable = true;
      gcs.enable = true;
      arduino.enable = true;
    };
  };
}
