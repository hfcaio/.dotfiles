{ pkgs, ... }: {
  imports = [
    ./hyprland.nix
    ./wayland.nix
    ./fonts.nix
    ./rofi.nix
    ./code.nix
    ./thunar.nix
    ./rpi_imager.nix
    ./latex.nix
  ];

  home.packages = with pkgs; [ xorg.xhost xorg.xauth ];
  services.udiskie.enable = true;
  services.udiskie.automount = true;
}
