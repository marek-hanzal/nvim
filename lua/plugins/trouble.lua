return {
	{
		"folke/trouble.nvim",
		cmd = {
			"Trouble",
		},
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics",
			},
			{
				"<leader>xb",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer diagnostics",
			},
			{
				"<leader>xq",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix",
			},
			{
				"<leader>xl",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location list",
			},
			{
				"<leader>xs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols",
			},
			{
				"<leader>xr",
				"<cmd>Trouble lsp_references toggle focus=false<cr>",
				desc = "LSP references",
			},
		},

		opts = {
			focus = true,
		},
	},
}
