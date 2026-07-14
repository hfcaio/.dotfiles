{ ... }:
{
  imports = [
    ../common
    ../features/cli
    ./home.nix
  ];

  features.cli = {
    zsh.enable = true;
    fetch.enable = true;
    starship.enable = true;
    lsp = {
      enable = true;
      cpp.enable    = true;
      nix.enable    = true;
      python.enable = true;
      lua.enable    = true;
    };
    nvim.enable = true;
    fzf.enable = true;
    direnv.enable = true;
    tmux.enable = true;
  };
}
