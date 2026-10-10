-- LSP 管理: mason は使わず、nvim-lspconfig + vim.lsp.config / vim.lsp.enable を使う。
--
--   * JS/TS 系サーバ : nvim/lsp/ の bun プロジェクト (package.json + bun.lock) で固定
--   * ネイティブ系   : Brewfile (lua_ls / ty / ruff) + rustup (rust_analyzer)
--
-- `bun --bun` は shebang (#!/usr/bin/env node) を無視して Bun ランタイムで実行するため、
-- node 未インストールでも動く。extra にはサーバ固有の引数 (--stdio 等) を渡す。
--   --stdio : LSP の通信路。nvim は stdin/stdout で JSON-RPC を話すので必須。
local lsp_bin = require("lsp_bin")

--- node ベースの LSP を bun で起動する cmd を返す。
--- プロジェクト内に node_modules/.bin/<name> があればそれを優先する。
---@param name string 実行ファイル名 (例: "typescript-language-server")
---@param extra string[]|nil サーバ固有の引数 (例: { "--stdio" })
local function bun_cmd(name, extra)
	return function(dispatchers, config)
		local local_bin = config.root_dir and vim.fs.joinpath(config.root_dir, "node_modules/.bin", name)
		local exe = (local_bin and vim.fn.executable(local_bin) == 1) and local_bin or (lsp_bin .. name)
		local cmd = { "bun", "--bun", exe }
		vim.list_extend(cmd, extra or {})
		return vim.lsp.rpc.start(cmd, dispatchers)
	end
end

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "Jint-lzxy/lsp_signature.nvim", opts = {} },
		{ "j-hui/fidget.nvim", opts = {} },
	},
	config = function()
		-- typescript-language-server -> ts_ls
		vim.lsp.config("ts_ls", { cmd = bun_cmd("typescript-language-server", { "--stdio" }) })
		-- yaml-language-server -> yamlls
		vim.lsp.config("yamlls", { cmd = bun_cmd("yaml-language-server", { "--stdio" }) })
		-- bash-language-server -> bashls ("start" が stdio モード)
		vim.lsp.config("bashls", { cmd = bun_cmd("bash-language-server", { "start" }) })
		-- vscode-langservers-extracted -> cssls / jsonls / html
		vim.lsp.config("cssls", { cmd = bun_cmd("vscode-css-language-server", { "--stdio" }) })
		vim.lsp.config("jsonls", { cmd = bun_cmd("vscode-json-language-server", { "--stdio" }) })
		vim.lsp.config("html", { cmd = bun_cmd("vscode-html-language-server", { "--stdio" }) })

		-- ネイティブ系 (lua_ls / ruff / ty / rust_analyzer) は nvim-lspconfig 既定の cmd を使う。
		vim.lsp.enable({
			"bashls",
			"cssls",
			"html",
			"jsonls",
			"lua_ls",
			"ruff",
			"rust_analyzer",
			"ts_ls",
			"ty",
			"yamlls",
		})
	end,
}
