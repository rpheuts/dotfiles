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
    echo "==> API:    http://127.0.0.1:8080/v1/chat/completions"
    echo "==> Web UI: http://127.0.0.1:8080"
    exec ${llama-cpp-vulkan}/bin/llama-server \
      --model "$MODEL" \
      --device Vulkan0 \
      --n-gpu-layers 99 \
      --spec-type draft-mtp \
      --alias "qwen,qwen3.8,default" \
      --ctx-size 16384 \
      --port 8080 \
      --host 127.0.0.1 \
      "$@"
  '';
in
{
  # System packages for local AI experimentation
  environment.systemPackages = [
    llama-cpp-vulkan
    llama-serve-vulkan
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

  # Ollama service (defaults to Vulkan; easily toggleable to pkgs.ollama-rocm)
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan; # Toggle to pkgs.ollama-rocm for ROCm testing
    host = "127.0.0.1";
    port = 11434;
  };
}
