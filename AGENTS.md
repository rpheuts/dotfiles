# Environment & Workstation Guidelines

- **System**: NixOS (x86_64-linux, unstable/26.05).
- **Root Permissions**: You have non-interactive, passwordless `sudo` privileges (`security.sudo.wheelNeedsPassword = false;`). You can directly run system-level operations, edit configuration files, and rebuild the OS without prompting for passwords.
- **Declarative System Management & Dotfiles**:
  - Central repository: `~/dotfiles` (Git-tracked dotfiles and multi-host NixOS configuration with Flakes).
  - Multi-host setup: `hosts/flow-z13` (ASUS Flow Z13, Strix Halo 128GB unified RAM), `hosts/book3` (Samsung Galaxy Book3 Pro 14", Intel i5-1340P), `hosts/template` (other machines).
  - Modules: `modules/common.nix`, `modules/desktop.nix`, `modules/llm.nix` (Vulkan local AI stack), `modules/gaming.nix` (Steam, Gamescope, GameMode).
  - Rebuild command: `sudo nixos-rebuild switch --flake ~/dotfiles` (or `sudo nixos-rebuild switch`).
  - Flakes and modern nix commands are enabled.
  - `services.envfs.enable = true` is active (resolves `/bin/bash` dynamically).
- **Desktop Environment**:
  - Window Manager: Hyprland (Lua configuration in `~/.config/hypr/hyprland.lua`). Apply changes via `hyprctl reload`.
  - Desktop Shell: Custom modular Quickshell top bar and widgets in `~/.config/quickshell/`.
  - Wallpapers: Managed natively by Quickshell via `~/.config/quickshell/bin/set-wallpaper` with images in `~/.config/quickshell/wallpapers/`.
  - Agent Overlay: Toggled via `Super + A` (`special:agent` scratchpad running Kitty with `agy`).
  - Login & Screen Lock: ReGreet (GTK4 / greetd) on boot; Hyprlock + Hypridle on sleep, lid close, and idle (`Super + L` to lock).
- **Terminal & Aesthetics**:
  - Terminal: Kitty (`~/.config/kitty/kitty.conf`) with 82% background opacity and JetBrainsMono Nerd Font.
  - Compositor: Frosted glass Gaussian blur on transparent surfaces (`blur.special = true`, `dim_special = 0.3`).
