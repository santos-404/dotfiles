#!/usr/bin/env bash
# Regression checks for preserving configs during install and uninstall.
set -euo pipefail
DOTS="$(cd "$(dirname "$0")/.." && pwd)"
TEST_DIR="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-tests.XXXXXX")"
trap 'rm -rf "$TEST_DIR"' EXIT
export HOME="$TEST_DIR/home"
export XDG_CONFIG_HOME="$TEST_DIR/config"
mkdir -p "$HOME" "$XDG_CONFIG_HOME/fish" "$XDG_CONFIG_HOME/ghostty/config"
printf 'keep this config\n' > "$XDG_CONFIG_HOME/fish/config.fish"
printf 'keep this directory\n' > "$XDG_CONFIG_HOME/ghostty/config/original"

bash "$DOTS/install.sh" --skip-plugins >/dev/null
test "$(readlink "$XDG_CONFIG_HOME/fish/config.fish")" = "$DOTS/fish/config.fish"
test "$(readlink "$XDG_CONFIG_HOME/tmux/tmux.conf")" = "$DOTS/tmux/tmux.conf"
test "$(find "$XDG_CONFIG_HOME/dotfiles/backups" -type f | wc -l | tr -d ' ')" = 2
grep -R -q 'keep this config' "$XDG_CONFIG_HOME/dotfiles/backups"
grep -R -q 'keep this directory' "$XDG_CONFIG_HOME/dotfiles/backups"

# Re-running must not replace correct links or create more backups.
bash "$DOTS/install.sh" --skip-plugins >/dev/null
test "$(find "$XDG_CONFIG_HOME/dotfiles/backups" -type f | wc -l | tr -d ' ')" = 2

# Removing this checkout must leave links owned by other configurations alone.
rm "$XDG_CONFIG_HOME/fish/config.fish"
ln -s "$TEST_DIR/another-config" "$XDG_CONFIG_HOME/fish/config.fish"
bash "$DOTS/unlink.sh" >/dev/null
test "$(readlink "$XDG_CONFIG_HOME/fish/config.fish")" = "$TEST_DIR/another-config"
test ! -L "$XDG_CONFIG_HOME/tmux/tmux.conf"
test ! -L "$XDG_CONFIG_HOME/ghostty/config.platform"
test ! -L "$HOME/.local/bin/dev"
printf 'Installer preservation checks passed.\n'
