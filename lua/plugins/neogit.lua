return {
	{
		"NeogitOrg/neogit",
		cmd = {
			"Neogit",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"folke/snacks.nvim",
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
				snacks = true,
			},

			diff_viewer = "diffview",
			graph_style = "unicode",

			signs = {
				hunk = { "", "" },
				item = { "", "" },
				section = { "", "" },
			},
		},
	},
}
