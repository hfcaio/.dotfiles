{ pkgs, config, lib, ... }:
with lib;
let cfg = config.features.cli.ollama;
in {
  options.features.cli.ollama.enable = mkEnableOption "enable local ollama server";

  config = mkIf cfg.enable {
    services.ollama = {
      enable = true;
      package = pkgs.unstable.ollama;
      environmentVariables = {
        # opencode manda prompts grandes; o padrao de 4k estoura
        OLLAMA_CONTEXT_LENGTH = "16384";
        OLLAMA_KEEP_ALIVE = "30m";
      };
    };
  };
}
