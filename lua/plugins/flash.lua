return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>jj",
				function()
					require("flash").jump()
				end,
				mode = {
					"n",
					"x",
					"o",
				},
				desc = "Jump",
			},
		},
		opts = {
			modes = {
				search = {
					enabled = false,
				},
				char = {
					enabled = false,
				},
			},
		},
	},
}
