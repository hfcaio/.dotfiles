{ pkgs, ... }:
{
  imports = [
    ./zsh.nix
    ./neofetch.nix
    ./starship.nix
    ./lsp_servers.nix
    ./python.nix
    ./fzf.nix
    ./nvim.nix
    ./direnv.nix
  ];

  home.packages = with pkgs; [
    coreutils
    btop
    tldr
    zip
    unzip
    wget
    nixfmt
  ];
}
