{ config, pkgs, ... }:

{
  # Steam Configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;                # Allow Steam Remote Play across local network
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = true; # Allow fast peer-to-peer game downloads on LAN
    gamescopeSession.enable = true;                # Steam Big Picture session option in greeter
    extraCompatPackages = [
      pkgs.proton-ge-bin                           # GloriousEggroll Proton build for maximum Windows game compatibility
    ];
    protontricks.enable = true;                    # Winetricks wrapper for Proton prefixes
  };

  # Gamescope micro-compositor for running games in an isolated, scalable Wayland window
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  # Feral GameMode to dynamically optimize CPU governor and priority
  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

  # Game controller udev rules (Steam Controller, Xbox, PlayStation, Nintendo Switch)
  hardware.steam-hardware.enable = true;

  # Additional Gaming Tools & Overlays
  environment.systemPackages = with pkgs; [
    mangohud       # Vulkan/OpenGL performance overlay (FPS, temperatures, power, VRAM)
    protonup-qt    # GUI tool to manage Proton-GE / Wine-GE versions easily
  ];
}
