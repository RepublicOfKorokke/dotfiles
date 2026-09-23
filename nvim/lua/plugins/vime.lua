return {
	"skanehira/vime.nvim",
	event = "VeryLazy",
	config = function()
		require("vime").setup({
			keymaps = {
				cancel = "<C-c>",
			},
			mode_notify = {
				enabled = true,
				duration = 1000, -- ms
				labels = {
					direct = "Mode: D",
					hiragana = "Mode: あ",
					ascii = "Mode: A",
				},
			},
		})
		vim.api.nvim_create_autocmd("InsertLeave", {
			pattern = "*",
			callback = function()
				local vime = require("vime")
				if vime.is_enabled() then
					-- vim.notify("vime toggle off")
					vime.toggle()
				end
			end,
		})
	end,
}
