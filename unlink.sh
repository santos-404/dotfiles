#!/usr/bin/env bash
# Remove all symlinks created by install.sh

TARGETS=(
    "$HOME/.tmux.conf"
    "$HOME/.tmux/local.conf"
    "$HOME/.tmux/ssh.conf"
    "$HOME/.config/fish/config.fish"
    "$HOME/.config/ghostty/config"
    "$HOME/.config/fastfetch/config.jsonc"
    "$HOME/.config/waybar/config.jsonc"
    "$HOME/.config/waybar/style.css"
    "$HOME/.config/waybar/scripts/wttr.py"
    "$HOME/.config/waybar/scripts/update-sys"
    "$HOME/.config/wofi/config"
    "$HOME/.config/wofi/style.css"
)

for target in "${TARGETS[@]}"; do
    if [ -L "$target" ]; then
        rm "$target"
        echo "removed $target"
    fi
done
