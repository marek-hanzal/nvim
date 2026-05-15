return {
	{
		"NeogitOrg/neogit",
		cmd = {
			"Neogit",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"ibhagwan/fzf-lua",
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
				fzf_lua = true,
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
