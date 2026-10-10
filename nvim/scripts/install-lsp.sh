#!/usr/bin/env bash
#
# Neovim の LSP / Formatter をセットアップする (mason 非使用)。
#   - ネイティブ系 : Brewfile  (lua_ls / ty / stylua / shfmt / taplo)
#   - Python 系    : uv tool   (ruff)
#   - Rust 系      : rustup component (rust_analyzer / rustfmt)
#   - JS/TS 系     : nvim/lsp の bun プロジェクト (package.json + bun.lock で固定)
#
# 詳細: nvim/docs/lsp.md
#
# Usage:
#   ./nvim/scripts/install-lsp.sh
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "[Info] Installing native LSP / formatters via Homebrew…"
brew bundle --file "$root/Brewfile"

echo "[Info] Installing Python LSP / formatter via uv…"
uv tool install ruff

echo "[Info] Installing Rust LSP / formatter via rustup…"
rustup component add rust-analyzer rustfmt

echo "[Info] Installing JS/TS LSP / formatters via bun…"
(cd "$root/nvim/lsp" && bun install --frozen-lockfile)

echo "[Info] Done. Run ':checkhealth vim.lsp' in Neovim to verify."
