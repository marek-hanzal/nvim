local function delete_other_buffers(force)
	local current_buffer = vim.api.nvim_get_current_buf()

	local deleted = 0
	local skipped = 0

	for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
		local is_current = buffer == current_buffer
		local is_valid = vim.api.nvim_buf_is_valid(buffer)
		local is_listed = vim.bo[buffer].buflisted
		local is_normal_file = vim.bo[buffer].buftype == ""
		local is_modified = vim.bo[buffer].modified

		if is_valid and is_listed and is_normal_file and not is_current then
			if is_modified and not force then
				skipped = skipped + 1
			else
				local ok = pcall(vim.api.nvim_buf_delete, buffer, {
					force = force,
				})

				if ok then
					deleted = deleted + 1
				else
					skipped = skipped + 1
				end
			end
		end
	end

	if skipped > 0 then
		vim.notify(
			string.format("Deleted %d buffers, skipped %d modified buffers", deleted, skipped),
			vim.log.levels.WARN
		)

		return
	end

	vim.notify(string.format("Deleted %d buffers", deleted))
end

local function setup_commands()
	vim.api.nvim_create_user_command("BufferDeleteOthers", function(opts)
		delete_other_buffers(opts.bang)
	end, {
		bang = true,
		desc = "Delete all listed file buffers except the current one",
	})
end

return {
	{
		name = "buffer-tools",
		dir = vim.fn.stdpath("config"),
		lazy = false,

		keys = {
			{
				"<leader>bo",
				"<cmd>BufferDeleteOthers<cr>",
				desc = "Delete other buffers",
			},
			{
				"<leader>bO",
				"<cmd>BufferDeleteOthers!<cr>",
				desc = "Force delete other buffers",
			},
		},

		config = function()
			setup_commands()
		end,
	},
}
