#!/usr/bin/env bash
# Core development tools; KDE keeps its own panel and launcher.
set -euo pipefail
WITH_GHOSTTY=false
case "${1:-}" in
    --with-ghostty) WITH_GHOSTTY=true ;;
    '') ;;
    *) echo "Usage: bash packages.sh [--with-ghostty]" >&2; exit 1 ;;
esac

if [ "$(uname -s)" = Darwin ]; then
    command -v brew >/dev/null || { echo 'Install Homebrew first: https://brew.sh' >&2; exit 1; }
    brew install fish tmux fastfetch fzf zoxide neovim ripgrep fd jq git go node
    if "$WITH_GHOSTTY"; then brew install --cask ghostty; fi
    exit
fi

if [ -f /run/ostree-booted ]; then
    echo 'This installer targets conventional Fedora KDE, not Kinoite/Atomic desktops.' >&2
    exit 1
fi

if command -v dnf >/dev/null; then
    sudo dnf install -y git curl unzip fish tmux fastfetch fzf zoxide neovim \
        ripgrep fd-find jq gcc gcc-c++ make golang nodejs npm \
        tree-sitter-cli wl-clipboard xclip jetbrains-mono-fonts google-noto-emoji-fonts
    if "$WITH_GHOSTTY"; then
        # Community COPR documented by Ghostty; DNF asks before enabling it.
        # https://ghostty.org/docs/install/binary#fedora
        sudo dnf install -y dnf-plugins-core
        sudo dnf copr enable scottames/ghostty
        sudo dnf install -y ghostty
    fi
elif command -v pacman >/dev/null; then
    sudo pacman -S --needed git curl unzip fish tmux fastfetch fzf zoxide neovim \
        ripgrep fd jq base-devel go nodejs npm wl-clipboard xclip ttf-jetbrains-mono noto-fonts-emoji
    if "$WITH_GHOSTTY"; then sudo pacman -S --needed ghostty; fi
elif command -v apt-get >/dev/null; then
    sudo apt-get update
    sudo apt-get install -y git curl unzip fish tmux fastfetch fzf zoxide neovim \
        ripgrep fd-find jq build-essential golang nodejs npm wl-clipboard xclip \
        fonts-jetbrains-mono fonts-noto-color-emoji
    if "$WITH_GHOSTTY"; then
        echo 'Install Ghostty for your Debian/Ubuntu version: https://ghostty.org/docs/install/binary' >&2
        exit 1
    fi
elif command -v zypper >/dev/null; then
    sudo zypper install -y git curl unzip fish tmux fastfetch fzf zoxide neovim \
        ripgrep fd jq gcc gcc-c++ make go nodejs npm wl-clipboard xclip
    if "$WITH_GHOSTTY"; then sudo zypper install -y ghostty; fi
else
    echo 'No supported package manager found (dnf, pacman, apt-get, zypper, brew).' >&2
    exit 1
fi

if ! "$WITH_GHOSTTY"; then
    echo 'Ghostty not requested. Use --with-ghostty to install it on supported distributions.'
fi
