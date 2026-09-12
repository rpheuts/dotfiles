{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/desktop.nix
    # Uncomment to enable Steam & Gaming stack on this laptop:
    # ../../modules/gaming.nix
  ];

  networking.hostName = "laptop";
}
