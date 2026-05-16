local map = require("keymap.util").map

local M = {}

function M.setup()
	map("n", "<leader>rr", "<cmd>OverseerRun<cr>", "Run task")
	map("n", "<leader>rt", "<cmd>OverseerToggle right<cr>", "Toggle tasks")
end

return M
