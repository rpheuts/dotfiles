{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/desktop.nix
    # Uncomment to enable Steam & Gaming stack on this laptop:
    # ../../modules/gaming.nix
  ];

  networking.hostName = "book3";

  boot.supportedFilesystems = [ "btrfs" ];

  # Samsung Galaxy Book3 Pro speaker amplifier quirk (Realtek ALC298 quad-speaker setup)
  boot.extraModprobeConfig = ''
    options snd_sof_intel_hda_generic hda_model=alc298-samsung-amp-v2-4-amps
  '';
}
