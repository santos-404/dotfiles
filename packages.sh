#!/usr/bin/env bash
# Install all tools managed by this dotfiles repo.
# Supports: Arch (pacman/paru), Debian/Ubuntu (apt), Fedora (dnf), openSUSE (zypper)

set -euo pipefail

# ---------------------------------------------------------------------------
# Package name map: common_name -> (arch apt dnf zypper)
# Use "-" to mark unavailable in a distro (will be skipped with a warning).
# ---------------------------------------------------------------------------
declare -A PKG_arch PKG_apt PKG_dnf PKG_zypper

# Shell & terminal
PKG_arch[fish]=fish;          PKG_apt[fish]=fish;             PKG_dnf[fish]=fish;             PKG_zypper[fish]=fish
PKG_arch[tmux]=tmux;          PKG_apt[tmux]=tmux;             PKG_dnf[tmux]=tmux;             PKG_zypper[tmux]=tmux
PKG_arch[ghostty]=ghostty;    PKG_apt[ghostty]=-;             PKG_dnf[ghostty]=-;             PKG_zypper[ghostty]=-
PKG_arch[fastfetch]=fastfetch; PKG_apt[fastfetch]=fastfetch;  PKG_dnf[fastfetch]=fastfetch;   PKG_zypper[fastfetch]=-

# Wayland / desktop (mostly Arch/wlroots ecosystem)
PKG_arch[waybar]=waybar;      PKG_apt[waybar]=waybar;         PKG_dnf[waybar]=waybar;         PKG_zypper[waybar]=waybar
PKG_arch[wofi]=wofi;          PKG_apt[wofi]=wofi;             PKG_dnf[wofi]=wofi;             PKG_zypper[wofi]=wofi
PKG_arch[rofi]=rofi;          PKG_apt[rofi]=rofi;             PKG_dnf[rofi]=rofi;             PKG_zypper[rofi]=rofi

# CLI utilities
PKG_arch[fzf]=fzf;            PKG_apt[fzf]=fzf;               PKG_dnf[fzf]=fzf;               PKG_zypper[fzf]=fzf

# Languages
PKG_arch[go]=go;              PKG_apt[go]=golang;             PKG_dnf[go]=golang;             PKG_zypper[go]=go

# Python deps (for waybar weather script)
PKG_arch[python-requests]=python-requests; PKG_apt[python-requests]=python3-requests; PKG_dnf[python-requests]=python3-requests; PKG_zypper[python-requests]=python3-requests

# All packages in install order
PACKAGES=(fish tmux ghostty fastfetch waybar wofi rofi fzf go python-requests)

# ---------------------------------------------------------------------------
# Detect distro and pick package manager
# ---------------------------------------------------------------------------
detect_pm() {
    if command -v paru &>/dev/null; then   echo "paru";   return; fi
    if command -v pacman &>/dev/null; then echo "pacman"; return; fi
    if command -v apt &>/dev/null; then    echo "apt";    return; fi
    if command -v dnf &>/dev/null; then    echo "dnf";    return; fi
    if command -v zypper &>/dev/null; then echo "zypper"; return; fi
    echo ""
}

PM=$(detect_pm)

if [ -z "$PM" ]; then
    echo "error: no supported package manager found (paru, pacman, apt, dnf, zypper)" >&2
    exit 1
fi

echo "Detected package manager: $PM"

# Map pm -> distro family for the name lookup table
case "$PM" in
    paru|pacman) FAMILY=arch ;;
    apt)         FAMILY=apt  ;;
    dnf)         FAMILY=dnf  ;;
    zypper)      FAMILY=zypper ;;
esac

# ---------------------------------------------------------------------------
# Build the install list, skipping unavailable packages
# ---------------------------------------------------------------------------
TO_INSTALL=()
SKIPPED=()

for pkg in "${PACKAGES[@]}"; do
    var="PKG_${FAMILY}[$pkg]"
    name="${!var:-}"
    if [ -z "$name" ] || [ "$name" = "-" ]; then
        SKIPPED+=("$pkg")
    else
        TO_INSTALL+=("$name")
    fi
done

if [ ${#SKIPPED[@]} -gt 0 ]; then
    echo "Skipping (not available via $PM): ${SKIPPED[*]}"
    echo "  ghostty: install manually from https://ghostty.org/download"
fi

if [ ${#TO_INSTALL[@]} -eq 0 ]; then
    echo "Nothing to install."
    exit 0
fi

# ---------------------------------------------------------------------------
# Install
# ---------------------------------------------------------------------------
echo "Installing: ${TO_INSTALL[*]}"

case "$PM" in
    paru)   paru   -S --needed "${TO_INSTALL[@]}" ;;
    pacman) sudo pacman -S --needed "${TO_INSTALL[@]}" ;;
    apt)    sudo apt install -y "${TO_INSTALL[@]}" ;;
    dnf)    sudo dnf install -y "${TO_INSTALL[@]}" ;;
    zypper) sudo zypper install -y "${TO_INSTALL[@]}" ;;
esac

echo "Done."
