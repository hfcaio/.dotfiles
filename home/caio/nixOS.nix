{ inputs, ... }:
{
  imports = [
    ../common
    ../features/cli
    ../features/desktop
    ./home.nix
    ./ssh.nix
  ];

  # ROS 2 so existe nesta maquina (input path:/home/caio/...), por isso o
  # overlay fica aqui e nao em home/common.
  nixpkgs.overlays = [ inputs.ros.overlays.default ];

  features = {
    cli = {
      zsh.enable = true;
      fetch.enable = true;
      starship.enable = true;
      lsp = {
        enable = true;
        cpp.enable = true;
        nix.enable = true;
        typst.enable = true;
        python.enable = true;
        lua.enable = true;
        copilot.enable = true;
      };
      nvim.enable = true;
      python.enable = true;
      fzf.enable = true;
      opencode.enable = true;
      ollama.enable = true;
      gh.enable = true;
      claude.enable = true;
      direnv.enable = true;
      eza.enable = true;
      tmux.enable = true;
    };
    desktop = {
      hyprland.enable = true;
      t3code.enable = true;
			quickshell.enable = true;
      mujoco.enable = true;
      ros2 = {
        enable = true;
        gui = true;
      };
      matlab.enable = true;
      fonts.enable = false;
      blender.enable = false;
      octave.enable = true;
      rofi.enable = true;
      rofi-powermenu.enable = true;
      rofi-bluetooth.enable = true;
      rofi-wifi.enable = true;
      thunar.enable = false;
      nautilus.enable = true;
      rpi_imager.enable = false;
      latex.enable = false;
      typst.enable = true;
      ipscan.enable = true;
      gcs.enable = true;
      arduino.enable = true;
      discord.enable = true;
      zen.enable = true;
      obs.enable = true;
      vagrant.enable = true;
      claude.enable = true;
      brave.enable = true;
      code.enable = true;
      onedrive.enable = true;
      vlc.enable = true;
      obsidian.enable = true;
      webots.enable = true;
    };
  };
}
