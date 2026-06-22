#!/usr/bin/env bash
# Remove all symlinks created by install.sh

DOTS="$(cd "$(dirname "$0")" && pwd)"

TARGETS=(
    "$HOME/.tmux.conf"
    "$HOME/.tmux/local.conf"
    "$HOME/.tmux/ssh.conf"
    "$HOME/.config/fish/config.fish"
    "$HOME/.config/ghostty/config"
    "$HOME/.config/fastfetch/config.jsonc"
    "$HOME/.config/opencode/opencode.jsonc"
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

for script in "$DOTS"/scripts/*; do
    [ -f "$script" ] || continue
    target="$HOME/.local/bin/$(basename "$script")"

    if [ -L "$target" ]; then
        rm "$target"
        echo "removed $target"
    fi
done
