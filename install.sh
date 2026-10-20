#!/usr/bin/env bash
# Link configs without discarding existing files. No packages or sudo required.
set -euo pipefail
DOTS="$(cd "$(dirname "$0")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP_DIR="$CONFIG_HOME/dotfiles/backups/$(date +%Y%m%d-%H%M%S)-$$"
SKIP_PLUGINS=false
case "${1:-}" in
    --skip-plugins) SKIP_PLUGINS=true ;;
    '') ;;
    *) echo "Usage: bash install.sh [--skip-plugins]" >&2; exit 1 ;;
esac

link() {
    local source="$1" target="$2" backup
    mkdir -p "$(dirname "$target")"
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        return
    fi
    if [ -e "$target" ] || [ -L "$target" ]; then
        backup="$BACKUP_DIR/${target#"$HOME"/}"
        mkdir -p "$(dirname "$backup")"
        mv "$target" "$backup"
        echo "Backed up $target to $backup"
    fi
    ln -s "$source" "$target"
    echo "$target -> $source"
}

install_tmux_resurrect() {
    local plugin="$HOME/.tmux/plugins/tmux-resurrect"
    if [ -d "$plugin/.git" ]; then
        echo "$plugin already installed"
    elif [ -e "$plugin" ]; then
        echo "error: $plugin exists but is not a git checkout" >&2
        return 1
    else
        mkdir -p "$(dirname "$plugin")"
        git clone --depth 1 https://github.com/tmux-plugins/tmux-resurrect "$plugin"
    fi
}

case "$(uname -s)" in
    Darwin) platform=macos ;;
    Linux) platform=linux ;;
    *) echo "Unsupported platform: $(uname -s)" >&2; exit 1 ;;
esac

for config in tmux/tmux.conf fish/config.fish ghostty/config fastfetch/config.jsonc opencode/opencode.jsonc; do
    link "$DOTS/$config" "$CONFIG_HOME/$config"
done
link "$DOTS/ghostty/config.$platform" "$CONFIG_HOME/ghostty/config.platform"

for script in "$DOTS"/scripts/*; do
    [ -f "$script" ] || continue
    link "$script" "$HOME/.local/bin/$(basename "$script")"
done

if ! "$SKIP_PLUGINS"; then
    install_tmux_resurrect
fi
printf '\nConfigs linked. Restart Fish and reload Ghostty/tmux to apply changes.\n'
