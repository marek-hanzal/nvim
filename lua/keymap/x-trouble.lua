local map = require("keymap.util").map

local M = {}

function M.setup()
	map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics")
	map("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer diagnostics")
	map("n", "<leader>xq", function()
		require("fzf-lua").quickfix({
			previewer = false,
		})
	end, "Quickfix")
	map("n", "<leader>xl", function()
		require("fzf-lua").loclist({
			previewer = false,
		})
	end, "Location list")
	map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", "Symbols")
	map("n", "<leader>xr", "<cmd>Trouble lsp_references toggle focus=false<cr>", "LSP references")
	map("n", "<leader>xt", function()
		require("todo-comments.fzf").todo({
			keywords = {
				"TODO",
				"NOTE",
			},
			prompt = "Todo> ",
			previewer = false,
			winopts = {
				title = " TODO List ",
				title_flags = false,
			},
		})
	end, "Todo comments")
end

return M
