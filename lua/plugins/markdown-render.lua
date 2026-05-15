return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = {
			"markdown",
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{
				"<leader>mp",
				"<cmd>RenderMarkdown toggle<cr>",
				desc = "Toggle markdown render",
			},
			{
				"<leader>mP",
				"<cmd>RenderMarkdown preview<cr>",
				desc = "Markdown preview",
			},
		},
		opts = {
			completions = {
				lsp = {
					enabled = true,
				},
			},
		},
	},
}
