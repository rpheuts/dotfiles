#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Setting up dotfiles from $DOTFILES_DIR"

# Ensure target directories exist
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.gemini/config/skills"

# Symlink user configs
echo "--> Linking user configurations..."
ln -sfn "$DOTFILES_DIR/config/hypr" "$HOME/.config/hypr"
ln -sfn "$DOTFILES_DIR/config/kitty" "$HOME/.config/kitty"
ln -sfn "$DOTFILES_DIR/config/quickshell" "$HOME/.config/quickshell"
ln -sfn "$DOTFILES_DIR/config/distrobox" "$HOME/.config/distrobox"
ln -sfn "$DOTFILES_DIR/config/rofi" "$HOME/.config/rofi"
ln -sfn "$DOTFILES_DIR/AGENTS.md" "$HOME/AGENTS.md"
ln -sfn "$DOTFILES_DIR/skills/nixos-desktop" "$HOME/.gemini/config/skills/nixos-desktop"
mkdir -p "$HOME/.distrobox"

# Symlink NixOS system configuration (requires sudo)
if [ -d "/etc/nixos" ]; then
    HOST="${1:-flow-z13}"
    echo "--> Linking NixOS system configuration for host: $HOST..."
    sudo ln -sfn "$DOTFILES_DIR/hosts/$HOST/default.nix" "/etc/nixos/configuration.nix"
    if [ -f "$DOTFILES_DIR/hosts/$HOST/hardware-configuration.nix" ]; then
        sudo ln -sfn "$DOTFILES_DIR/hosts/$HOST/hardware-configuration.nix" "/etc/nixos/hardware-configuration.nix"
    fi
fi

# Ensure user directory has proper traversal permissions for Nix builds
chmod 755 "$HOME"

echo "==> Dotfiles setup complete!"
echo "To apply NixOS changes:  sudo nixos-rebuild switch --flake ~/dotfiles"
echo "To reload Hyprland:      hyprctl reload"
