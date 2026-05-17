local map = require("keymap.util").map

local M = {}

local function open_task_output(task)
	local bufnr = task:get_bufnr()
	if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	local winid = vim.api.nvim_get_current_win()
	local prev_bufnr = vim.api.nvim_win_get_buf(winid)
	local prev_filetype = vim.bo[prev_bufnr].filetype
	local from_terminal_mode = vim.api.nvim_get_mode().mode:sub(1, 1) == "t"

	vim.defer_fn(function()
		if not vim.api.nvim_win_is_valid(winid) or not vim.api.nvim_buf_is_valid(bufnr) then
			return
		end

		vim.api.nvim_win_set_buf(winid, bufnr)
		pcall(function()
			require("overseer.util").set_term_window_opts(winid)
			require("overseer.util").scroll_to_end(winid)
		end)

		if from_terminal_mode then
			vim.cmd.startinsert()
		end

		if prev_filetype == "OverseerOutput" and prev_bufnr ~= bufnr and vim.api.nvim_buf_is_valid(prev_bufnr) then
			pcall(vim.api.nvim_buf_delete, prev_bufnr, { force = true })
		end
	end, 10)
end

local function run_task()
	local overseer = require("overseer")
	local opts = {
		search_params = {
			dir = vim.fn.getcwd(),
		},
	}

	local function on_run(task, err)
		if err then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end

		if task then
			open_task_output(task)
		end
	end

	overseer.run_task(opts, on_run)
end

function M.setup()
	map("n", "<leader>rr", run_task, "Run task")
	map("n", "<leader>rt", "<cmd>OverseerTaskAction<cr>", "Task actions")
end

return M
