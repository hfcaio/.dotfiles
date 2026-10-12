{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.features.cli.nvim;
in
{
  options.features.cli.nvim.enable = mkEnableOption "install neovim plugins and configure neovim";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      yazi
      kdePackages.qtdeclarative
    ];
    programs.neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;

      plugins = with pkgs.vimPlugins; [
        catppuccin-nvim
        telescope-nvim
        blink-cmp
        harpoon
        yazi-nvim
        lualine-nvim
        # Sorter nativo do telescope (C). Sem ele o live_grep fica lento assim
        # que o projecto cresce.
        telescope-fzf-native-nvim
      ];

      # O live_grep do telescope invoca o rg; o find_files prefere o fd. Aqui
      # ficam no PATH do proprio nvim, para nao dependerem de o
      # features.cli.fzf estar ligado nem do PATH da shell que o lancou.
      extraPackages = with pkgs; [
        ripgrep
        fd
      ];

      initLua = builtins.readFile ./nvim/init.lua;
    };
  };
}
