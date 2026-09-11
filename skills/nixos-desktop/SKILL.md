---
name: nixos-desktop
description: Comprehensive knowledge, guidelines, and procedures for administering this NixOS workstation, Hyprland desktop environment, Quickshell top bar and widgets, and AGY agent automation. Activate when modifying system packages, NixOS configurations, Hyprland settings, Quickshell UI, or desktop utilities.
---

# NixOS & Hyprland Desktop Administration Guide

This system is an AMD-powered Linux laptop running **NixOS** with **Hyprland** (Lua configuration) and a custom modular **Quickshell** desktop environment.

## 1. System Environment & Privileges
- **Operating System**: NixOS (26.05 / unstable) with `flakes` and `nix-command` enabled.
- **Root Permissions**: Passwordless `sudo` is enabled for user `rpheuts` (`security.sudo.wheelNeedsPassword = false;`).
- **Autonomous Execution**: You have permission to directly execute `sudo` commands, install software, edit system files, and rebuild the system without waiting for password prompts.
- **Shebang Resolution**: `services.envfs.enable = true` is active, allowing standard `#!/bin/bash` scripts to execute cleanly.

## 2. NixOS Configuration & Dotfiles Repository
- **Central Repository**: `~/dotfiles` (Git repository containing NixOS system config, desktop configs, and AGY skills).
- **Configuration File**: `/etc/nixos/configuration.nix` (symlinked to `~/dotfiles/nixos/configuration.nix`).
- **Standard System Packages**: Add to `environment.systemPackages = with pkgs; [ ... ];` in `~/dotfiles/nixos/configuration.nix`.
- **System Services**: Configure declaratively in `~/dotfiles/nixos/configuration.nix` (e.g. `services.upower.enable = true;`).
- **Rebuilding the System**:
  ```bash
  sudo nixos-rebuild switch
  ```
- **Flake/Ad-hoc Packages**:
  Can be run via `nix run nixpkgs#<pkg>` or added permanently to the user profile via:
  ```bash
  nix profile add nixpkgs#<pkg>
  ```

- **Containers & Distrobox**: Podman is enabled rootless (`dockerCompat = true`). Distrobox containers use home isolation (`container_home_prefix = "${HOME}/.distrobox"` in `/etc/distrobox/distrobox.conf` and `~/.config/distrobox/distrobox.conf`), isolating all container dotfiles, profiles, and binaries to `~/.distrobox/<name>/` while providing access to host files at `/home/rpheuts` (`$DISTROBOX_HOST_HOME`).

## 3. Hyprland Configuration
- **Configuration File**: `~/.config/hypr/hyprland.lua`
- **Syntax**: Lua configuration (`hl.config`, `hl.bind`, `hl.window_rule`, `hl.animation`).
- **Applying Changes**:
  ```bash
  hyprctl reload
  ```
- **Active Keybindings**:
  - `Super + Return`: Terminal (`kitty`)
  - `Super + W`: Close active window
  - `Super + B`: Browser (`chromium`)
  - `Super + F`: Toggle full fullscreen (zero gaps, covers bar)
  - `Super + Shift + F`: Toggle maximize (monocle mode, retains top bar)
  - `Super + R` / `Super + Space`: Application launcher (`rofi`)
  - `Super + A`: Toggle persistent AGY CLI slide-in overlay (`special:agent`)
  - `Super + L`: Lock screen immediately (`hyprlock`)
  - `Super + Shift + W`: Cycle to next wallpaper
- **Aesthetic Styling**:
  - Gaps: `gaps_in = 3`, `gaps_out = 6`
  - Border: 1px subtle frosted silver (`rgba(cacccc99)`)
  - Translucency & Blur: Multi-pass Gaussian frosted glass with `blur.special = true` and `dim_special = 0.3`.

## 4. Quickshell Desktop Environment
- **Configuration Directory**: `~/.config/quickshell/`
- **Entry Point**: `~/.config/quickshell/shell.qml`
- **Plugin Manifest & Layout**: `~/.config/quickshell/shell.json`
- **Helper Scripts**: `~/.config/quickshell/bin/` (included in `$PATH`)
- **Active Widgets**:
  - **Workspaces**: Left-hand workspace switcher
  - **Clock**: Center day & time (`dddd HH:mm`) with calendar popup
  - **Monitor**: Display brightness slider and dynamic display scale factor
  - **Power**: Battery percentage, wattage, and `powerprofilesctl` power modes
  - **Audio**: Volume slider and output audio sink switcher
  - **Network**: Wi-Fi connection info and SSID scan picker
  - **Background**: Native desktop wallpaper layer
- **Process Management**:
  ```bash
  quickshell -d                  # Start daemon in background
  quickshell ipc call <target>   # Communicate with running shell
  ```

## 5. Wallpaper Management
- **Wallpapers Directory**: `~/.config/quickshell/wallpapers/`
- **Current Symlink**: `~/.config/quickshell/current_wallpaper`
- **CLI Management**:
  ```bash
  set-wallpaper /path/to/image.png   # Set specific wallpaper
  set-wallpaper --next               # Cycle through available wallpapers
  ```
- **Supported Formats**: PNG, JPG (converted from WebP for Qt image compatibility).
- **Desktop Gesture**: Double-click empty desktop space to open wallpaper picker.

## 6. AGY CLI Persistent Overlay
- **Toggle Script**: `~/.config/quickshell/bin/agy-toggle`
- **Hyprland Workspace**: `special:agent`
- **Window Class**: `agy-overlay` (size: 1150x680, centered)

## 7. Login Manager & Screen Locking
- **Boot / Cold Start Login**: `greetd` with `regreet` (GTK4 Wayland greeter running inside `cage`).
  - Wallpaper: `/etc/greetd/wallpaper.png`
  - Sessions discovered via `environment.pathsToLink = [ "/share/wayland-sessions" ];`
- **Lock Screen**: `hyprlock` (`~/.config/hypr/hyprlock.conf`).
  - Frosted glass blur over dynamic `~/.config/quickshell/current_wallpaper`.
  - Manual lock shortcut: `Super + L`
- **Idle & Sleep Daemon**: `hypridle` (`~/.config/hypr/hypridle.conf`).
  - Locks screen via `loginctl lock-session` before system suspend or lid close.
  - Idle timeouts: 5m lock, 6m display off, 30m suspend.

## 8. Local LLM Architecture (Flow Z13 / Strix Halo 128GB)
- **Hardware Profile**: AMD Strix Halo APU (Radeon 8060S / RDNA 3.5) with 128GB unified memory (~66GB+ VRAM allocatable to Vulkan/ROCm).
- **Vulkan Acceleration**:
  - `llama-cpp` compiled with `vulkanSupport = true` (`llama-server`, `llama-cli`, `llama-bench`).
  - Devices: `Vulkan0` (RADV STRIX_HALO). Vulkan avoids GPU fence lockups and compositor stutter on Wayland.
  - Multi-Token Prediction (MTP) / Speculative Decoding: `--spec-type draft-mtp` supported natively.
  - Helper launcher: `llama-serve-vulkan <model.gguf> [args...]`
- **Ollama Service**:
  - `services.ollama.enable = true` running `ollama-vulkan` on port 11434 (swappable to `ollama-rocm` in `modules/llm.nix`).
- **Host Separation**:
  - `modules/llm.nix` is only imported on `hosts/flow-z13/`. Other hosts omit it to avoid heavy compute overhead.

## 9. Gaming & Steam Stack (`modules/gaming.nix`)
- **Module**: `modules/gaming.nix` (imported in `hosts/flow-z13/default.nix`).
- **Steam**: Sandboxed bubblewrap FHS environment with 32-bit graphics support, local network transfer, and remote play firewall configurations.
- **Proton Compatibility**: `pkgs.proton-ge-bin` (GE-Proton) pre-installed into Steam compatibility tools, plus `protonup-qt` GUI for managing versions and `protontricks`.
- **Gamescope Session & Micro-Compositor**: `programs.gamescope` enabled with `capSysNice = true` for isolated Wayland scaling, FSR, and optional Big Picture session in greeter.
- **GameMode**: `programs.gamemode` enabled with renicing support (`gamemoderun <game>`).
- **Controller Support**: `hardware.steam-hardware.enable = true` providing udev rules for Steam, Xbox, PlayStation, and Switch controllers.
- **Performance HUD**: `mangohud` available (`mangohud <game>`).

