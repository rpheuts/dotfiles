{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/desktop.nix
    ../../modules/llm.nix
    ../../modules/gaming.nix
  ];

  # Machine Hostname
  networking.hostName = "flow-z13";

  # Strix Halo AMDGPU driver module in initrd
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Dynamic unified memory allocation for Strix Halo iGPU (128GB RAM):
  # - amdgpu.gttsize=102400: Allows the GPU to dynamically allocate up to 100GB of RAM (total ~104GB with VRAM)
  # - amdgpu.no_system_mem_limit=1: Allows single large compute allocations (for 70B+ LLMs)
  boot.kernelParams = [
    "amdgpu.gttsize=102400"
    "amdgpu.no_system_mem_limit=1"
  ];
}
