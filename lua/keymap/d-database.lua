local map = require("keymap.util").map

local M = {}

function M.setup()
	map("n", "<leader>dd", "<cmd>DBUIToggle<cr>", "Toggle database UI")
	map("n", "<leader>df", "<cmd>DBUIFindBuffer<cr>", "Find database buffer")
end

return M
