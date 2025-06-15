{ pkgs, ... }: {
  imports =
    [ ./zsh.nix ./neofetch.nix ./starship.nix ./qt_apps.nix ./lsp_servers.nix ];

  home.packages = with pkgs; [
    coreutils
    btop
    tldr
    zip
    unzip
    wget
    nixfmt-classic
  ];
}
