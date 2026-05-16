local map = require("keymap.util").map

local M = {}

function M.setup()
	map("n", "<leader><leader>", "<cmd>FzfLua files<cr>", "Find files")
	map("n", "<leader>fk", "<cmd>FzfLua keymaps<cr>", "Find keymaps")
	map("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", "Recent files")
	map("n", "<leader>fR", "<cmd>FzfLua resume<cr>", "Resume picker")
	map("n", "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", "Find document symbols")
	map("n", "<leader>fS", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", "Find workspace symbols")
	map("n", "/", "<cmd>FzfLua blines<cr>", "Fuzzy search buffer lines")
	map("n", "<leader>/", "/", "Native search")
	map("n", "<leader>fa", function()
		require("fzf-lua").grep({
			search = "",
			prompt = "Project fuzzy> ",
		})
	end, "Fuzzy search project lines")
	map("n", "<leader>ft", "<cmd>TodoFzfLua<cr>", "Find todo comments")
end

return M
