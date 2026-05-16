local map = require("keymap.util").map

local M = {}

function M.setup()
	map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics")
	map("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer diagnostics")
	map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", "Quickfix")
	map("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", "Location list")
	map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", "Symbols")
	map("n", "<leader>xr", "<cmd>Trouble lsp_references toggle focus=false<cr>", "LSP references")
	map("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>", "Todo comments")
end

return M
