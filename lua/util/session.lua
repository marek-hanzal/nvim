local buffer_prune = require("util.buffer_prune")

local M = {}

local function is_disposable_blank(bufnr)
	return vim.api.nvim_buf_is_valid(bufnr)
		and vim.bo[bufnr].buftype == ""
		and vim.api.nvim_buf_get_name(bufnr) == ""
		and not vim.bo[bufnr].modified
		and vim.api.nvim_buf_line_count(bufnr) == 1
		and (vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or "") == ""
end

local function current_argument_buffer()
	local argc = vim.fn.argc()

	if argc == 0 then
		return nil
	end

	local argidx = vim.fn.argidx()
	local argument = vim.fn.argv(argidx >= 0 and argidx < argc and argidx or 0)

	if not argument or argument == "" then
		return nil
	end

	for _, name in ipairs({ argument, vim.fn.fnamemodify(argument, ":p") }) do
		local bufnr = vim.fn.bufnr(name)

		if bufnr ~= -1 and buffer_prune.is_file_buffer(bufnr) then
			return bufnr
		end
	end

	return nil
end

local function focus_buffer(bufnr)
	local winid = vim.fn.bufwinid(bufnr)

	if winid ~= -1 then
		vim.api.nvim_set_current_win(winid)
	else
		vim.api.nvim_set_current_buf(bufnr)
	end

	buffer_prune.touch(bufnr)
end

function M.prepare_save()
	buffer_prune.prune()

	local current = vim.api.nvim_get_current_buf()

	if buffer_prune.is_file_buffer(current) then
		buffer_prune.touch(current)
		return
	end

	local latest = buffer_prune.latest_file_buffer()

	if latest then
		focus_buffer(latest)
	end
end

function M.restore_focus()
	local current = vim.api.nvim_get_current_buf()

	if buffer_prune.is_file_buffer(current) then
		buffer_prune.touch(current)
		buffer_prune.schedule_prune()
		return
	end

	local target = current_argument_buffer() or buffer_prune.latest_file_buffer()

	if not target then
		return
	end

	focus_buffer(target)

	if is_disposable_blank(current) and #vim.fn.win_findbuf(current) == 0 then
		pcall(vim.api.nvim_buf_delete, current, { force = false })
	end

	buffer_prune.schedule_prune()
end

function M.setup(persistence)
	local group = vim.api.nvim_create_augroup("session_lifecycle", { clear = true })

	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "PersistenceSavePre",
		nested = true,
		callback = M.prepare_save,
	})

	vim.api.nvim_create_autocmd("User", {
		group = group,
		pattern = "PersistenceLoadPost",
		nested = true,
		callback = M.restore_focus,
	})

	vim.api.nvim_create_autocmd("VimEnter", {
		group = group,
		nested = true,
		callback = function()
			if vim.fn.argc() == 0 then
				persistence.load()
			end
		end,
	})
end

return M
