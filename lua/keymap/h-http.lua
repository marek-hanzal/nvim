local map = require("keymap.util").map

local M = {}

local function focus_kulala_window()
	vim.schedule(function()
		local ui = require("kulala.ui")
		local win = ui.get_kulala_window and ui.get_kulala_window()

		if win and vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_set_current_win(win)
		end
	end)
end

local function run_and_focus(run_fn)
	require("kulala.api").on("after_next_request", function()
		focus_kulala_window()
	end)

	run_fn()
end

function M.setup()
	map("n", "<leader>hr", function()
		run_and_focus(function()
			require("kulala").run()
		end)
	end, "Run HTTP request")

	map("n", "<leader>ha", function()
		run_and_focus(function()
			require("kulala").run_all()
		end)
	end, "Run all HTTP requests")

	map("n", "<leader>ht", function()
		require("kulala").toggle_view()
	end, "Toggle HTTP response")

	map("n", "<leader>hi", function()
		require("kulala").inspect()
	end, "Inspect HTTP request")
end

return M
