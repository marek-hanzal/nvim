return {
	{
		"NeogitOrg/neogit",
		cmd = {
			"Neogit",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
		},
		keys = {
			{
				"<leader>gg",
				function()
					require("neogit").open({
						kind = "tab",
					})
				end,
				desc = "Open Neogit",
			},
		},

		opts = {
			integrations = {
				diffview = true,
			},

			graph_style = "unicode",

			signs = {
				hunk = { "", "" },
				item = { "", "" },
				section = { "", "" },
			},
		},
	},
}
