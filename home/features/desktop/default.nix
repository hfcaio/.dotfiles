{ pkgs, ... }: {
  imports = [ ./hyprland.nix ./wayland.nix ./fonts.nix ./rofi.nix ./code.nix ];

  home.packages = with pkgs; [ ];
}
