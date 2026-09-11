# Dotfiles & NixOS Configuration

Personal configuration repository for NixOS, Hyprland, Quickshell, Kitty, and Antigravity (AGY).

## System Architecture & Stack

- **OS**: NixOS (x86_64-linux, unstable / 26.05)
- **Window Manager**: [Hyprland](https://hyprland.org) (configured in Lua: `~/.config/hypr/hyprland.lua`)
- **Desktop Shell**: [Quickshell](https://quickshell.outfoxxed.me) (modular top bar & wallpaper engine in `~/.config/quickshell/`)
- **Terminal**: [Kitty](https://sw.kovidgoyal.net/kitty/) with JetBrainsMono Nerd Font & frosted glass opacity
- **AI Agent Integration**: [Antigravity](https://github.com/google-deepmind) CLI (`agy`) persistent scratchpad overlay on `Super + A`

## Repository Structure

```text
dotfiles/
├── nixos/
│   ├── configuration.nix           # Main NixOS system configuration
│   └── hardware-configuration.nix  # Hardware scan & kernel modules
├── config/
│   ├── hypr/
│   │   ├── hyprland.lua            # Hyprland bindings, rules & blur
│   │   ├── hyprlock.conf           # Lock screen styling & geometry
│   │   └── hypridle.conf           # Idle & suspend lock timeouts
│   ├── kitty/
│   │   └── kitty.conf              # Terminal font, opacity & keymaps
│   └── quickshell/
│       ├── shell.qml               # Shell entry point
│       ├── shell.json              # Plugin & widget manifest
│       ├── Ui/                     # Custom UI component library
│       ├── Commons/                # Styling and geometry helpers
│       ├── plugins/                # Modular bar & panel plugins
│       ├── wallpapers/             # Wallpaper gallery
│       └── bin/                    # Desktop helper scripts (agy-toggle, set-wallpaper)
├── skills/
│   └── nixos-desktop/
│       └── SKILL.md                # System administration skill for AGY
├── AGENTS.md                       # Always-on AGY pair programming instructions
├── install.sh                      # Symlink installer script
└── README.md
```

## Quick Start & Installation

To link all dotfiles and system configurations to their expected locations:

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Workflow & Common Tasks

### 1. System Changes & Software Installation
Edit `nixos/configuration.nix` and rebuild:
```bash
sudo nixos-rebuild switch
```

### 2. Window Manager & Styling
Edit `config/hypr/hyprland.lua` and apply immediately:
```bash
hyprctl reload
```

### 3. Desktop Shell & Wallpapers
- Switch or cycle wallpapers:
  ```bash
  set-wallpaper /path/to/image.png
  set-wallpaper --next      # Or press Super + Shift + W
  ```
- Toggle AGY overlay: `Super + A`
- Lock screen: `Super + L` (or automatic on sleep / 5m idle)
