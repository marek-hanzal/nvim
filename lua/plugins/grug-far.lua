return {
	{
		"MagicDuck/grug-far.nvim",
		cmd = {
			"GrugFar",
			"GrugFarWithin",
		},
		keys = {
			{
				"<leader>sr",
				function()
					require("grug-far").open()
				end,
				mode = {
					"n",
					"x",
				},
				desc = "Search and replace",
			},
			{
				"<leader>sR",
				function()
					require("grug-far").open({
						prefills = {
							paths = vim.fn.expand("%"),
						},
					})
				end,
				desc = "Search and replace current file",
			},
		},
		opts = {
			headerMaxWidth = 80,
		},
	},
}
