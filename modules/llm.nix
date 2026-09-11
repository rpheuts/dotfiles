{ config, pkgs, lib, ... }:

let
  # llama.cpp built with Vulkan backend for RADV Strix Halo acceleration
  llama-cpp-vulkan = pkgs.llama-cpp.override {
    vulkanSupport = true;
  };

  # Helper script to launch llama-server with Vulkan offloading & optional MTP
  llama-serve-vulkan = pkgs.writeShellScriptBin "llama-serve-vulkan" ''
    #!/usr/bin/env bash
    set -euo pipefail
    if [ $# -lt 1 ]; then
      echo "Usage: llama-serve-vulkan <path-to-model.gguf> [extra llama-server flags...]"
      echo "Example with MTP:"
      echo "  llama-serve-vulkan ./qwen-3.8.gguf --spec-type draft-mtp -c 8192"
      exit 1
    fi
    MODEL="$1"
    shift
    echo "==> Starting llama-server with Vulkan acceleration on Strix Halo..."
    exec ${llama-cpp-vulkan}/bin/llama-server \
      --model "$MODEL" \
      --device Vulkan0 \
      --n-gpu-layers 99 \
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

  # Ollama service (defaults to Vulkan; easily toggleable to pkgs.ollama-rocm)
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan; # Toggle to pkgs.ollama-rocm for ROCm testing
    host = "127.0.0.1";
    port = 11434;
  };
}
