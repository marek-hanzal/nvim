local map = require("keymap.util").map

local M = {}

function M.setup()
	map("n", "<leader>qs", function()
		require("persistence").load()
	end, "Restore session")

	map("n", "<leader>ql", function()
		require("persistence").load({ last = true })
	end, "Restore last session")

	map("n", "<leader>qd", function()
		require("persistence").stop()
	end, "Disable session save")
end

return M
