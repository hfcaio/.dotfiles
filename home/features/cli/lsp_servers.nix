{ pkgs, config, lib, ... }:
with lib;
let cfg = config.features.cli.lsp;
in {
  options.features.cli.lsp.enable =
    mkEnableOption "download LSP server packages";

  config = mkIf cfg.enable {

    home.packages = with pkgs; [ lua-language-server clang-tools pyright nil tinymist arduino-language-server ];
  };
}

