{pkgs, ...}: {
  imports = [
    ./zsh.nix
    ./neofetch.nix
    ./starship.nix
  ];

  home.packages = with pkgs; [
    coreutils
    btop
    tldr
    zip
    unzip
    wget
    git
    nixfmt-classic
  ];
}