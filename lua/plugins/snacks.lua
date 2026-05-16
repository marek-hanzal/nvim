return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			input = {
				enabled = true,
			},
			bigfile = {
				enabled = true,
				notify = true,
				size = 5 * 1024 * 1024,
				line_length = 1000,
			},
			bufdelete = {
				enabled = true,
			},
			lazygit = {
				enabled = true,
				configure = true,
				config = {
					gui = {
						nerdFontsVersion = "3",
					},
				},
			},
			styles = {
				lazygit = {
					width = 0,
					height = 0,
				},
			},
		},
		config = function(_, opts)
			require("snacks").setup(opts)
		end,
	},
}
