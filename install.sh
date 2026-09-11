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
ln -sfn "$DOTFILES_DIR/AGENTS.md" "$HOME/AGENTS.md"
ln -sfn "$DOTFILES_DIR/skills/nixos-desktop" "$HOME/.gemini/config/skills/nixos-desktop"

# Symlink NixOS system configuration (requires sudo)
if [ -d "/etc/nixos" ]; then
    echo "--> Linking NixOS system configuration..."
    sudo ln -sfn "$DOTFILES_DIR/nixos/configuration.nix" "/etc/nixos/configuration.nix"
    sudo ln -sfn "$DOTFILES_DIR/nixos/hardware-configuration.nix" "/etc/nixos/hardware-configuration.nix"
fi

# Ensure user directory has proper traversal permissions for Nix builds
chmod 755 "$HOME"

echo "==> Dotfiles setup complete!"
echo "To apply NixOS changes:  sudo nixos-rebuild switch"
echo "To reload Hyprland:      hyprctl reload"
