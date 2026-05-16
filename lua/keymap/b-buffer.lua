local map = require("keymap.util").map

local M = {}

function M.setup()
	map("n", "<leader>bn", "<cmd>bnext<cr>", "Next buffer")
	map("n", "<leader>bp", "<cmd>bprevious<cr>", "Previous buffer")
	map("n", "<leader>ba", "<cmd>buffer #<cr>", "Alternate buffer")

	map("n", "<leader>bd", function()
		Snacks.bufdelete()
	end, "Delete buffer")

	map("n", "<leader>bD", function()
		Snacks.bufdelete({ force = true })
	end, "Force delete buffer")

	map("n", "<leader>bo", function()
		Snacks.bufdelete.other({
			filter = function(buffer)
				return vim.bo[buffer].buflisted and vim.bo[buffer].buftype == ""
			end,
		})
	end, "Delete other buffers")
end

return M
