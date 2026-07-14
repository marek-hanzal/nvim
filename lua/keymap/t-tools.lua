local map = require("keymap.util").map

local M = {}

function M.setup()
	map("n", "<leader>tn", function()
		require("todo-comments").jump_next()
	end, "Next todo comment")

	map("n", "<leader>tp", function()
		require("todo-comments").jump_prev()
	end, "Previous todo comment")

	map("n", "<leader>tg", "<cmd>TagsGenerate<cr>", "Generate project tags")

	map("n", "<leader>th", function()
		Snacks.notifier.show_history()
	end, "Notification history")

	map("n", "<leader>tw", function()
		vim.opt_local.list = not vim.opt_local.list:get()
	end, "Toggle whitespace")
end

return M
