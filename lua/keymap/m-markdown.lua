local map = require("keymap.util").map

local M = {}

function M.setup()
	map("n", "<leader>mp", "<cmd>RenderMarkdown toggle<cr>", "Toggle markdown render")
	map("n", "<leader>mP", "<cmd>RenderMarkdown preview<cr>", "Markdown preview")
end

return M
