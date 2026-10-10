-- JS/TS 系 LSP / formatter の実行ファイル置き場 (nvim/lsp の bun プロジェクト)。
-- ~/.config は .dotfiles への symlink なので resolve して実パスを得る。
-- 例: <lsp_bin>typescript-language-server, <lsp_bin>prettier
return vim.fn.resolve(vim.fn.stdpath("config")) .. "/lsp/node_modules/.bin/"
