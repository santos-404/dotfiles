#!/usr/bin/env bash
DOTS="$(cd "$(dirname "$0")" && pwd)"
TMUX_RESURRECT_DIR="$HOME/.tmux/plugins/tmux-resurrect"

link() {
    mkdir -p "$(dirname "$2")"
    ln -sf "$1" "$2"
    echo "$2 -> $1"
}

install_tmux_resurrect() {
    if [ -d "$TMUX_RESURRECT_DIR/.git" ]; then
        echo "$TMUX_RESURRECT_DIR already installed"
        return
    fi

    if [ -e "$TMUX_RESURRECT_DIR" ]; then
        echo "error: $TMUX_RESURRECT_DIR exists but is not a git checkout" >&2
        return 1
    fi

    mkdir -p "$(dirname "$TMUX_RESURRECT_DIR")"
    git clone https://github.com/tmux-plugins/tmux-resurrect "$TMUX_RESURRECT_DIR"
}

link "$DOTS/tmux/tmux.conf"            "$HOME/.config/tmux/tmux.conf"
link "$DOTS/fish/config.fish"         "$HOME/.config/fish/config.fish"
link "$DOTS/ghostty/config"           "$HOME/.config/ghostty/config"
link "$DOTS/fastfetch/config.jsonc"   "$HOME/.config/fastfetch/config.jsonc"
link "$DOTS/opencode/opencode.jsonc"  "$HOME/.config/opencode/opencode.jsonc"

for script in "$DOTS"/scripts/*; do
    [ -f "$script" ] || continue
    link "$script" "$HOME/.local/bin/$(basename "$script")"
done

install_tmux_resurrect
