{ pkgs, ... }: {
  imports = [
    ./hyprland.nix
    ./wayland.nix
    ./fonts.nix
    ./rofi.nix
    ./code.nix
    ./thunar.nix
  ];

  home.packages = with pkgs; [ xorg.xhost xorg.xauth ];
  services.udiskie.enable = true;
  services.udiskie.automount = true;
}
