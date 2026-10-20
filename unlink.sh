#!/usr/bin/env bash
# Remove only links that still point to this checkout. Backups are retained.
set -euo pipefail
DOTS="$(cd "$(dirname "$0")" && pwd)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

unlink_owned() {
    local target="$1" source="$2"
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        rm "$target"
        echo "removed $target"
    fi
}

for config in tmux/tmux.conf fish/config.fish ghostty/config fastfetch/config.jsonc opencode/opencode.jsonc; do
    unlink_owned "$CONFIG_HOME/$config" "$DOTS/$config"
done
for platform in macos linux; do
    unlink_owned "$CONFIG_HOME/ghostty/config.platform" "$DOTS/ghostty/config.$platform"
done
for script in "$DOTS"/scripts/*; do
    [ -f "$script" ] || continue
    unlink_owned "$HOME/.local/bin/$(basename "$script")" "$script"
done
