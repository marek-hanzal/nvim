local map = require("keymap.util").map

local M = {}

function M.setup()
	map("n", "<leader>hr", function()
		require("kulala").run()
	end, "Run HTTP request")

	map("n", "<leader>ha", function()
		require("kulala").run_all()
	end, "Run all HTTP requests")

	map("n", "<leader>ht", function()
		require("kulala").toggle_view()
	end, "Toggle HTTP response")

	map("n", "<leader>hi", function()
		require("kulala").inspect()
	end, "Inspect HTTP request")
end

return M
