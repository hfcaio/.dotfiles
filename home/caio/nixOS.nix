{ ... }:
{
  imports = [
    ../common
    ../features/cli
    ../features/desktop
    ./home.nix
    ./ssh.nix
  ];

  features = {
    cli = {
      zsh.enable = true;
      fetch.enable = true;
      starship.enable = true;
      lsp = {
        enable = true;
        cpp.enable     = true;
        arduino.enable = true;
        nix.enable     = true;
        typst.enable   = true;
        python.enable  = true;
        lua.enable     = true;
      };
      nvim.enable    = true;
      python.enable  = true;
      fzf.enable     = true;
      direnv.enable  = true;
      tmux.enable    = true;
    };
    desktop = {
      hyprland.enable      = true;
      fonts.enable         = false;
      blender.enable       = false;
      octave.enable        = true;
      rofi.enable          = true;
      rofi-powermenu.enable = true;
      thunar.enable        = false;
      nautilus.enable      = true;
      rpi_imager.enable    = false;
      latex.enable         = false;
      typst.enable         = true;
      ipscan.enable        = true;
      gcs.enable           = true;
      arduino.enable       = true;
      discord.enable       = true;
      obs.enable           = true;
      vagrant.enable       = true;
      claude.enable        = true;
    };
  };
}
