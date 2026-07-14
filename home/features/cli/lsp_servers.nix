{ pkgs, config, lib, ... }:
with lib;
let cfg = config.features.cli.lsp;
in {
  options.features.cli.lsp = {
    enable = mkEnableOption "download LSP server packages";

    cpp.enable    = mkOption { type = types.bool; default = false; description = "C/C++ LSP (clangd)"; };
    arduino.enable = mkOption { type = types.bool; default = false; description = "Arduino LSP (arduino-language-server + clangd)"; };
    nix.enable    = mkOption { type = types.bool; default = false; description = "Nix LSP (nil)"; };
    typst.enable  = mkOption { type = types.bool; default = false; description = "Typst LSP (tinymist)"; };
    python.enable = mkOption { type = types.bool; default = false; description = "Python LSP (pyright)"; };
    lua.enable    = mkOption { type = types.bool; default = false; description = "Lua LSP (lua-language-server)"; };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      (optionals cfg.cpp.enable    [ clang-tools ])
      ++ (optionals cfg.arduino.enable [ arduino-language-server clang-tools ])
      ++ (optionals cfg.nix.enable    [ nil ])
      ++ (optionals cfg.typst.enable  [ tinymist ])
      ++ (optionals cfg.python.enable [ pyright ])
      ++ (optionals cfg.lua.enable    [ lua-language-server ]);
  };
}
