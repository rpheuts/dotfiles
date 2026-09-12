# Dotfiles & NixOS Configuration

Personal configuration repository for NixOS, Hyprland, Quickshell, Kitty, and Antigravity (AGY).

## System Architecture & Stack

- **OS**: NixOS (x86_64-linux, unstable / 26.05)
- **Window Manager**: [Hyprland](https://hyprland.org) (configured in Lua: `~/.config/hypr/hyprland.lua`)
- **Desktop Shell**: [Quickshell](https://quickshell.outfoxxed.me) (modular top bar & wallpaper engine in `~/.config/quickshell/`)
- **Terminal**: [Kitty](https://sw.kovidgoyal.net/kitty/) with JetBrainsMono Nerd Font & frosted glass opacity
- **Containers**: Rootless [Podman](https://podman.io) & [Distrobox](https://distrobox.it) for mutable distribution environments
- **AI Agent Integration**: [Antigravity](https://github.com/google-deepmind) CLI (`agy`) persistent scratchpad overlay on `Super + A`

## Repository Structure

```text
dotfiles/
├── flake.nix                       # Multi-host Flake definition
├── hosts/
│   ├── flow-z13/                   # ASUS Flow Z13 (Strix Halo 128GB unified RAM)
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   ├── book3/                      # Samsung Galaxy Book3 Pro 14" (Intel i5-1340P, ALC298)
│   │   ├── default.nix
│   │   └── hardware-configuration.nix
│   └── template/                   # Template for other machines (no heavy AI stack)
│       └── default.nix
├── modules/
│   ├── common.nix                  # Core OS, users, audio, power, containers
│   ├── desktop.nix                 # Hyprland, greeter (regreet/greetd), locks, fonts
│   └── llm.nix                     # Local AI: Vulkan llama.cpp (MTP support) & Ollama
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
./install.sh book3       # Or flow-z13 / template
```

## Workflow & Common Tasks

### 1. System Changes & Rebuilding
Edit files in `modules/` or `hosts/<hostname>/`, then rebuild:
```bash
sudo nixos-rebuild switch --flake ~/dotfiles
```

### 2. Local LLMs & Speculative Decoding (Flow Z13)
- **Ollama (Vulkan-accelerated)**:
  Runs automatically on `127.0.0.1:11434`.
  ```bash
  ollama run qwen2.5:32b
  ```
- **llama.cpp with Vulkan & MTP (Multiple Token Prediction)**:
  Run Qwen with MTP using the helper launcher:
  ```bash
  llama-serve-vulkan /path/to/qwen-3.8.gguf --spec-type draft-mtp -c 8192
  ```
  Or run directly with `llama-cli`:
  ```bash
  llama-cli -m /path/to/model.gguf --device Vulkan0 -ngl 99 --spec-type draft-mtp -p "Hello!"
  ```

### 3. Window Manager & Styling
Edit `config/hypr/hyprland.lua` and apply immediately:
```bash
hyprctl reload
```

### 4. Desktop Shell & Wallpapers
- Switch or cycle wallpapers:
  ```bash
  set-wallpaper /path/to/image.png
  set-wallpaper --next      # Or press Super + Shift + W
  ```
- Toggle AGY overlay: `Super + A`
- Lock screen: `Super + L` (or automatic on sleep / 5m idle)
