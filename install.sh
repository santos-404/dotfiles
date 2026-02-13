#!/usr/bin/env bash
DOTS="$(cd "$(dirname "$0")" && pwd)"

link() {
    mkdir -p "$(dirname "$2")"
    ln -sf "$1" "$2"
    echo "$2 -> $1"
}

link "$DOTS/tmux/.tmux.conf"          "$HOME/.tmux.conf"
link "$DOTS/tmux/local.conf"          "$HOME/.tmux/local.conf"
link "$DOTS/tmux/ssh.conf"            "$HOME/.tmux/ssh.conf"
link "$DOTS/fish/config.fish"         "$HOME/.config/fish/config.fish"
link "$DOTS/ghostty/config"           "$HOME/.config/ghostty/config"
link "$DOTS/fastfetch/config.jsonc"   "$HOME/.config/fastfetch/config.jsonc"
link "$DOTS/waybar/config.jsonc"      "$HOME/.config/waybar/config.jsonc"
link "$DOTS/waybar/style.css"         "$HOME/.config/waybar/style.css"
link "$DOTS/waybar/scripts/wttr.py"   "$HOME/.config/waybar/scripts/wttr.py"
link "$DOTS/waybar/scripts/update-sys" "$HOME/.config/waybar/scripts/update-sys"
link "$DOTS/wofi/config"              "$HOME/.config/wofi/config"
link "$DOTS/wofi/style.css"           "$HOME/.config/wofi/style.css"
