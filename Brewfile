# Neovim の LSP / Formatter 用ネイティブツール (mason 非使用)。
# 詳細: nvim/docs/lsp.md
# node 依存の ts_ls / yamlls / bashls / cssls / jsonls / html / prettier は
# nvim/lsp の bun プロジェクト側で管理する。
#
# rust_analyzer (LSP) と rustfmt (formatter) は rustup で管理する:
#   rustup component add rust-analyzer rustfmt
#
# ruff (LSP + formatter: ruff_fix / ruff_format / ruff_organize_imports) は uv で管理する:
#   uv tool install ruff

# lua_ls -> *.lua          (LSP)
brew "lua-language-server"
# ty     -> *.py           (LSP / type checker)
brew "ty"
# stylua -> *.lua          (formatter)
brew "stylua"
# shfmt  -> *.sh / *.bash  (formatter)
brew "shfmt"
# taplo  -> *.toml         (formatter)
brew "taplo"
