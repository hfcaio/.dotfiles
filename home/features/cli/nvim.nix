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
        telescope-fzf-native-nvim
        # tree-sitter highlight (the regex syntax breaks on multi-line TS exports); started in init.lua
        (nvim-treesitter.withPlugins (p: [
          p.typescript p.tsx p.javascript p.json
          p.c p.cpp p.cmake p.proto p.nix p.lua p.bash p.markdown
        ]))
      ];

      # O live_grep do telescope invoca o rg; o find_files prefere o fd.
      extraPackages = with pkgs; [
        ripgrep
        fd
      ];

      initLua = builtins.readFile ./nvim/init.lua;
    };
  };
}
