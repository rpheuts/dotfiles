{ config, pkgs, ... }:

{
  # Window Manager
  programs.hyprland.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Wrap quickshell with QtMultimedia support for video wallpapers
  nixpkgs.overlays = [
    (final: prev: {
      quickshell = prev.symlinkJoin {
        name = "quickshell";
        paths = [ prev.quickshell ];
        buildInputs = [ prev.makeWrapper ];
        postBuild = ''
          rm $out/bin/quickshell
          makeWrapper ${prev.quickshell}/bin/quickshell $out/bin/quickshell \
            --prefix QML_IMPORT_PATH : "${prev.qt6.qtmultimedia}/lib/qt-6/qml" \
            --prefix QT_PLUGIN_PATH : "${prev.qt6.qtmultimedia}/lib/qt-6/plugins"
        '';
      };
    })
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
