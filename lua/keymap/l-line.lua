local map = require("keymap.util").map

local M = {}

function M.setup()
	map("x", "<leader>ls", ":Sort<cr>", "Sort selection")
	map("x", "<leader>lS", ":Sort!<cr>", "Sort selection reverse")
	map("x", "<leader>lu", ":Sort u<cr>", "Sort selection unique")
end

return M
