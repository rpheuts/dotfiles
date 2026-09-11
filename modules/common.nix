{ config, pkgs, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.networkmanager.enable = true;

  # User management
  security.sudo.wheelNeedsPassword = false;

  users.users."rpheuts" = {
    isNormalUser = true;
    description = "Robert Heuts";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [
      chromium
    ];
  };

  # Localization & Timezone
  time.timeZone = "Europe/Amsterdam";
  environment.variables.TZDIR = "/etc/zoneinfo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Audio & Hardware Daemons
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  services.envfs.enable = true;

  # Nix Package Manager & Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Containers & Distrobox
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # Common System Packages
  environment.systemPackages = with pkgs; [
    distrobox
    xhost
    gh
    git
    kitty
    brightnessctl
    jq
    inotify-tools
    wireplumber
  ];

  system.stateVersion = "26.05";
}
