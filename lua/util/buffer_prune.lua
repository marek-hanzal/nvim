local M = {}

local state = {
	last_used = {},
	tick = 0,
	prune_scheduled = false,
}

local defaults = {
	max_file_buffers = 12,
}

local function config()
	return vim.tbl_extend("force", defaults, vim.g.buffer_prune or {})
end

function M.is_file_buffer(bufnr)
	return vim.api.nvim_buf_is_valid(bufnr)
		and vim.bo[bufnr].buflisted
		and vim.bo[bufnr].buftype == ""
		and vim.api.nvim_buf_get_name(bufnr) ~= ""
end

local function is_visible(bufnr)
	for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
		if vim.api.nvim_win_is_valid(winid) then
			return true
		end
	end

	return false
end

local function file_buffers()
	return vim.tbl_filter(M.is_file_buffer, vim.api.nvim_list_bufs())
end

function M.touch(bufnr)
	if not M.is_file_buffer(bufnr) then
		return
	end

	state.tick = state.tick + 1
	state.last_used[bufnr] = state.tick
end

function M.latest_file_buffer()
	local latest

	for _, bufnr in ipairs(file_buffers()) do
		if
			not latest
			or (state.last_used[bufnr] or 0) > (state.last_used[latest] or 0)
			or ((state.last_used[bufnr] or 0) == (state.last_used[latest] or 0) and bufnr > latest)
		then
			latest = bufnr
		end
	end

	return latest
end

function M.count()
	return #file_buffers()
end

function M.prune()
	local max_buffers = config().max_file_buffers

	if type(max_buffers) ~= "number" or max_buffers < 1 then
		return {}
	end

	local buffers = file_buffers()
	local overflow = #buffers - math.floor(max_buffers)

	if overflow <= 0 then
		return {}
	end

	local candidates = vim.tbl_filter(function(bufnr)
		return not vim.bo[bufnr].modified and not is_visible(bufnr)
	end, buffers)

	table.sort(candidates, function(a, b)
		local a_last_used = state.last_used[a] or 0
		local b_last_used = state.last_used[b] or 0

		if a_last_used ~= b_last_used then
			return a_last_used < b_last_used
		end

		return a < b
	end)

	local deleted = {}

	for _, bufnr in ipairs(candidates) do
		if #deleted >= overflow then
			break
		end

		if pcall(vim.api.nvim_buf_delete, bufnr, { force = false }) then
			state.last_used[bufnr] = nil
			deleted[#deleted + 1] = bufnr
		end
	end

	return deleted
end

function M.schedule_prune()
	if state.prune_scheduled then
		return
	end

	state.prune_scheduled = true

	vim.schedule(function()
		state.prune_scheduled = false
		M.prune()
	end)
end

function M.setup()
	local group = vim.api.nvim_create_augroup("buffer_prune", { clear = true })

	vim.api.nvim_create_autocmd("BufEnter", {
		group = group,
		callback = function(event)
			M.touch(event.buf)
			M.schedule_prune()
		end,
	})

	vim.api.nvim_create_autocmd({ "BufAdd", "BufFilePost", "BufHidden", "BufWinEnter" }, {
		group = group,
		callback = M.schedule_prune,
	})

	vim.api.nvim_create_autocmd("BufDelete", {
		group = group,
		callback = function(event)
			state.last_used[event.buf] = nil
		end,
	})
end

return M
