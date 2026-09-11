{ config, pkgs, ... }:

{
  # Window Manager
  programs.hyprland.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Desktop Shell & Launcher
  environment.systemPackages = with pkgs; [
    quickshell
    rofi
    papirus-icon-theme
  ];

  # Graphical Greeter (ReGreet + greetd)
  services.displayManager.regreet = {
    enable = true;
    settings = {
      background = {
        path = "/etc/greetd/wallpaper.png";
        fit = "Cover";
      };
      GTK = {
        application_prefer_dark_theme = true;
      };
      commands = {
        reboot = [ "systemctl" "reboot" ];
        poweroff = [ "systemctl" "poweroff" ];
      };
    };
  };

  # Provide login screen wallpaper asset
  environment.etc."greetd/wallpaper.png".source = ../config/quickshell/wallpapers/quattro.png;

  # Ensure Wayland sessions are discoverable by greeters
  environment.pathsToLink = [ "/share/wayland-sessions" ];

  # Screen locker and idle management
  programs.hyprlock.enable = true;
}
