local map = require("keymap.util").map

local M = {}

local function run_task()
	require("overseer").run_task({
		search_params = {
			dir = vim.fn.getcwd(),
		},
	})
end

function M.setup()
	map("n", "<leader>rr", run_task, "Run task")
	map("n", "<leader>rt", "<cmd>OverseerTaskAction<cr>", "Task actions")
end

return M
