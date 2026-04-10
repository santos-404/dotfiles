#!/usr/bin/env bash
DOTS="$(cd "$(dirname "$0")" && pwd)"

link() {
    mkdir -p "$(dirname "$2")"
    ln -sf "$1" "$2"
    echo "$2 -> $1"
}

link "$DOTS/tmux/tmux.conf"            "$HOME/.config/tmux/tmux.conf"
link "$DOTS/fish/config.fish"         "$HOME/.config/fish/config.fish"
link "$DOTS/ghostty/config"           "$HOME/.config/ghostty/config"
link "$DOTS/fastfetch/config.jsonc"   "$HOME/.config/fastfetch/config.jsonc"
