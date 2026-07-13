local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
require("util.buffer_prune").setup()

autocmd("TextYankPost", {
	group = augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

autocmd("TextYankPost", {
	group = augroup("copy_yank_delete_to_clipboard", { clear = true }),
	callback = function()
		local event = vim.v.event

		if (event.operator ~= "y" and event.operator ~= "d") or event.regname ~= "" then
			return
		end

		vim.fn.setreg("+", event.regcontents, event.regtype)
	end,
})
