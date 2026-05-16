local map = require("keymap.util").map

local M = {}

function M.setup()
	map("n", "<leader>tn", function()
		require("todo-comments").jump_next()
	end, "Next todo comment")

	map("n", "<leader>tp", function()
		require("todo-comments").jump_prev()
	end, "Previous todo comment")
end

return M
