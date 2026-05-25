local M = {}

local state = {
	last_used = {},
	tick = 0,
	scheduled = false,
}

local defaults = {
	max_listed_buffers = 12,
}

local function config()
	return vim.tbl_extend("force", defaults, vim.g.buffer_prune or {})
end

local function is_regular_buffer(bufnr)
	return vim.api.nvim_buf_is_valid(bufnr)
		and vim.bo[bufnr].buflisted
		and vim.bo[bufnr].buftype == ""
end

local function is_visible(bufnr)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == bufnr then
			return true
		end
	end

	return false
end

local function listed_regular_buffers()
	local buffers = {}

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if is_regular_buffer(bufnr) then
			table.insert(buffers, bufnr)
		end
	end

	return buffers
end

function M.touch(bufnr)
	if not is_regular_buffer(bufnr) then
		return
	end

	state.tick = state.tick + 1
	state.last_used[bufnr] = state.tick
end

function M.prune()
	local max_buffers = config().max_listed_buffers

	if type(max_buffers) ~= "number" or max_buffers < 1 then
		return
	end

	local buffers = listed_regular_buffers()
	local overflow = #buffers - max_buffers

	if overflow <= 0 then
		return
	end

	local current = vim.api.nvim_get_current_buf()
	local candidates = {}

	for _, bufnr in ipairs(buffers) do
		if bufnr ~= current and not vim.bo[bufnr].modified and not is_visible(bufnr) then
			table.insert(candidates, bufnr)
		end
	end

	table.sort(candidates, function(a, b)
		return (state.last_used[a] or 0) < (state.last_used[b] or 0)
	end)

	for index = 1, math.min(overflow, #candidates) do
		local bufnr = candidates[index]

		pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
		state.last_used[bufnr] = nil
	end
end

function M.schedule_prune()
	if state.scheduled then
		return
	end

	state.scheduled = true

	vim.schedule(function()
		state.scheduled = false
		M.prune()
	end)
end

function M.setup()
	local group = vim.api.nvim_create_augroup("buffer_prune", { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
		group = group,
		callback = function(args)
			M.touch(args.buf)
			M.schedule_prune()
		end,
	})

	vim.api.nvim_create_autocmd("BufDelete", {
		group = group,
		callback = function(args)
			state.last_used[args.buf] = nil
		end,
	})
end

return M
