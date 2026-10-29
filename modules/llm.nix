{ config, pkgs, lib, ... }:

let
  # llama.cpp built with Vulkan backend for RADV Strix Halo acceleration
  llama-cpp-vulkan = pkgs.llama-cpp.override {
    vulkanSupport = true;
  };

  # Helper script to launch llama-server with Vulkan offloading & MTP
  llama-serve-vulkan = pkgs.writeShellScriptBin "llama-serve-vulkan" ''
    #!/usr/bin/env bash
    set -euo pipefail
    DEFAULT_MODEL="/home/rpheuts/Downloads/Qwen3.8-27B-Q6_K_L.gguf"
    MODEL="''${1:-$DEFAULT_MODEL}"
    if [ $# -ge 1 ]; then shift; fi

    if [ ! -f "$MODEL" ]; then
      echo "Error: Model file not found at: $MODEL"
      echo "Usage: llama-serve-vulkan [path-to-model.gguf] [extra llama-server flags...]"
      exit 1
    fi

    echo "==> Starting local LLM server with Vulkan acceleration & MTP on Strix Halo..."
    echo "==> Model: $MODEL"
    echo "==> API:    http://0.0.0.0:8080/v1/chat/completions"
    echo "==> Web UI: http://0.0.0.0:8080"
    exec ${llama-cpp-vulkan}/bin/llama-server \
      --model "$MODEL" \
      --device Vulkan0 \
      --n-gpu-layers 99 \
      --spec-type draft-mtp \
      --alias "qwen,qwen3.8,default" \
      --ctx-size 16384 \
      --port 8080 \
      --host 0.0.0.0 \
      "$@"
  '';

  # Helper script to import an arbitrary GGUF into Ollama
  ollama-import-gguf = pkgs.writeShellScriptBin "ollama-import-gguf" ''
    #!/usr/bin/env bash
    set -euo pipefail
    DEFAULT_MODEL="/home/rpheuts/Downloads/Qwen3.8-27B-Q6_K_L.gguf"
    MODEL_PATH="''${1:-$DEFAULT_MODEL}"
    MODEL_NAME="''${2:-qwen}"
    CTX_SIZE="''${3:-16384}"

    if [ ! -f "$MODEL_PATH" ]; then
      echo "Error: GGUF model not found at $MODEL_PATH"
      echo "Usage: ollama-import-gguf [path/to/model.gguf] [model_name] [context_size]"
      exit 1
    fi

    TMP_MODELFILE=$(mktemp /tmp/Modelfile.XXXXXX)
    trap 'rm -f "$TMP_MODELFILE"' EXIT

    cat > "$TMP_MODELFILE" << EOF
FROM $MODEL_PATH
PARAMETER num_ctx $CTX_SIZE
EOF

    echo "==> Registering '$MODEL_NAME' in Ollama from: $MODEL_PATH..."
    ollama create "$MODEL_NAME" -f "$TMP_MODELFILE"
    echo ""
    echo "==> Model '$MODEL_NAME' is registered and ready in Ollama!"
    echo "==> Chat in terminal:               ollama run $MODEL_NAME"
    echo "==> API endpoint:                   http://10.0.0.150:11434/v1/chat/completions"
    echo "==> Model name for API calls:       $MODEL_NAME"
  '';
in
{
  # Firewall: Allow LAN devices to reach local LLM endpoints
  networking.firewall.allowedTCPPorts = [
    8080   # llama-server (Qwen)
    11434  # Ollama
  ];

  # System packages for local AI experimentation
  environment.systemPackages = [
    llama-cpp-vulkan
    llama-serve-vulkan
    ollama-import-gguf
    pkgs.vulkan-tools       # vulkaninfo
    pkgs.clinfo
  ];

  # On-demand systemd user service:
  #   Start with: systemctl --user start qwen
  #   Stop with:  systemctl --user stop qwen
  systemd.user.services.qwen = {
    description = "Local Qwen 3.8 27B LLM Server with Vulkan & MTP";
    serviceConfig = {
      ExecStart = "${llama-serve-vulkan}/bin/llama-serve-vulkan";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # Ollama service (Vulkan backend with Strix Halo iGPU enabled)
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
    host = "0.0.0.0";
    port = 11434;
    environmentVariables = {
      OLLAMA_IGPU_ENABLE = "1";
    };
  };
}
