{ pkgs, config, lib, ... }:
with lib;
let cfg = config.features.cli.opencode;
in {
  options.features.cli.opencode.enable = mkEnableOption "enable opencode support";

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      package = pkgs.unstable.opencode;
      web.enable = true;
      settings.provider.ollama = {
        npm = "@ai-sdk/openai-compatible";
        name = "Ollama (local)";
        options.baseURL = "http://localhost:11434/v1";
        models."hf.co/12bitmisfit/Qwen3-Coder-30B-A3B-Instruct_Pruned_REAP-15B-A3B-GGUF:Q4_K_M" = {
          name = "Qwen3-Coder 15B-A3B REAP (local)";
        };
      };
    };
  };
}
