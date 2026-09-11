{ config, pkgs, ... }:

{
  imports = [
    # Include hardware configuration generated on this machine:
    # ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/desktop.nix
    # Note: ../../modules/llm.nix is intentionally omitted for machines
    # without heavy AI acceleration hardware.
  ];

  networking.hostName = "laptop";
}
