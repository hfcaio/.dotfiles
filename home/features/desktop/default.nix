{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./fonts.nix
    ./rofi.nix
    ./rofi_pw_menu.nix
    ./blender.nix
		./octave.nix
    ./discord.nix
    ./code.nix
    ./thunar.nix
    ./nautilus.nix
    ./rpi_imager.nix
    ./latex.nix
    ./ipscan.nix
    ./gcs.nix
    ./arduino.nix
		./typst.nix
  ];

  home.packages = with pkgs; [
    xorg.xhost
    xorg.xauth
  ];
  services.udiskie.enable = true;

}
