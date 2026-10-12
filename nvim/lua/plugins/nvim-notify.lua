return {
	"rcarriga/nvim-notify",
	lazy = false,
	config = function()
		require("notify").setup({
			background_colour = "#000000",
			timeout = 1500,
			fps = 60,
			stages = "slide",
			top_down = false,
		})
		vim.notify = require("notify")
		-- vim.api.nvim_create_autocmd({ "BufRead" }, {
		--     pattern = { "*" },
		--     command = "lua vim.notify('BufRead ' .. vim.fn.expand('%'))",
		-- })
		-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
		--     pattern = { "*" },
		--     command = "lua vim.notify('BufEnter ' .. vim.fn.expand('%'))",
		-- })
		--
		-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
		--     pattern = { "*" },
		--     command = "lua vim.notify('VimEnter ' .. vim.fn.expand('%'))",
		-- })
		--
		-- vim.api.nvim_create_autocmd({ "FileType" }, {
		--     pattern = { "lua" },
		--     command = "lua vim.notify('FileType' .. vim.fn.expand('%'))",
		-- })
		-- vim.api.nvim_create_autocmd({ "LspAttach" }, {
		--     pattern = { "*" },
		--     command = "lua vim.notify('LspAttach to: ' .. vim.fn.expand('%'))",
		-- })
		-- vim.api.nvim_create_autocmd({ "LspDetach" }, {
		-- 	pattern = { "*" },
		-- 	command = "lua vim.notify('LspDetach from: ' .. vim.fn.expand('%'))",
		-- })
	end,
}
