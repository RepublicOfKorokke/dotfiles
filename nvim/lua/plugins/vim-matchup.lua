return {
	"andymass/vim-matchup",
	-- event = { "BufReadPre", "BufNewFile" },
	init = function()
		vim.g.matchup_matchparen_deferred = 1
		vim.g.matchup_matchparen_deferred_show_delay = 500
		vim.g.matchup_matchparen_deferred_hide_delay = 700
		vim.g.matchup_matchparen_offscreen = { method = "popup" }
	end,
}
