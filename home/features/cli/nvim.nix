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
      ];

      extraLuaConfig = builtins.readFile ./nvim/init.lua;
    };
  };
}
