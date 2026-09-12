{ config, pkgs, inputs, ... }:

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

  # Secret Service & Keyring (for Mailspring, Chromium, VS Code, etc.)
  services.gnome.gnome-keyring.enable = true;

  # Enable nix-ld to seamlessly run generic unpatched dynamic binaries (e.g. agy CLI)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
  ];

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

  virtualisation.containers.registries.settings = {
    unqualified-search-registries = [ "docker.io" "quay.io" ];
  };

  # Distrobox configuration: Isolate container home directories
  environment.etc."distrobox/distrobox.conf".text = ''
    # Automatically isolate container home directories to avoid host profile contamination
    container_home_prefix="''${HOME}/.distrobox"
  '';

  # Common System Packages
  environment.systemPackages = with pkgs; [
    inputs.antigravity-nix.packages.${pkgs.system}.google-antigravity-cli
    distrobox
    xhost
    gh
    git
    kitty
    brightnessctl
    jq
    inotify-tools
    wireplumber
    python3
    pi-coding-agent
    vscodium
    libva-utils
  ];

  system.stateVersion = "26.05";
}
