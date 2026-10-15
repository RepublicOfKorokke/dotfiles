vim.loader.enable() -- byte-compiles and caches Lua files

-- disable default vim plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.api.nvim_create_user_command("FormatJson", "%!jq '.'", {})
vim.api.nvim_create_user_command("Unicode2Text", function()
	vim.cmd([[:%s/\\u\(\x\{4\}\)/\=nr2char(str2nr(submatch(1), 16))/g]])
end, { desc = "Convert Unicode escape sequences to text" })
