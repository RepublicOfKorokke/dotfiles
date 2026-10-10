#!/bin/bash

# install-deps.sh
# -----------------
# Installs all dependencies listed in requirement.md using Homebrew.
# Only supported on macOS or Linux distributions.
#
# Usage:
#   ./install-deps.sh            # Installs all packages

set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
    echo "[Error] Homebrew not found." >&2
    echo "[Info] Installing Homebrew."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    exit 1
fi

echo "[Info] Installing dependencies via Homebrew…"

packages=(
    tmux
    neovim
    fzf
    zoxide
    bat
    ripgrep
    fd
    viddy
    gron
    vivid
    bottom
    leaf
)

for pkg in "${packages[@]}"; do
    echo "[Info] Installing ${pkg} …"
    brew install "${pkg}" || {
        echo "[ERROR] Failed to install ${pkg}." >&2
        exit 1
    }
done

echo "[INFO] All dependencies installed successfully."
