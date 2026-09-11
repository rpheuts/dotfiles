{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/desktop.nix
    ../../modules/llm.nix
  ];

  # Machine Hostname
  networking.hostName = "flow-z13";

  # Strix Halo AMDGPU driver module in initrd
  boot.initrd.kernelModules = [ "amdgpu" ];
}
