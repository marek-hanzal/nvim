-- Highlight yanks

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
	group = augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.cmd("Neotree toggle filesystem reveal left")
		vim.cmd("wincmd p")
	end,
})
