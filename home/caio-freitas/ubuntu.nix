{ ... }:
{
  imports = [
    ../common
    ../features/cli
    # So apps GUI avulsos: o resto de features/desktop e especifico do NixOS/Hyprland.
    ../features/desktop/t3code.nix
    ../features/desktop/obsidian.nix
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
      web.enable    = true;
    };
    nvim.enable = true;
    fzf.enable = true;
    direnv.enable = true;
    opencode.enable = true;
    tmux.enable = true;
  };

  features.desktop.t3code = {
    enable = true;
    nixGL = true;
  };

  features.desktop.obsidian = {
    enable = true;
    nixGL = true;
  };
}
