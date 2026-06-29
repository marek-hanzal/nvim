return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			input = {
				enabled = true,
			},
			notifier = {
				enabled = true,
				timeout = 8000,
				style = "compact",
				top_down = false,
				icons = {
					error = " ",
					warn = " ",
					info = " ",
					debug = " ",
					trace = "✎ ",
				},
			},
			indent = {
				enabled = true,
				indent = {
					char = "│",
				},
				scope = {
					enabled = true,
					underline = false,
				},
				animate = {
					enabled = true,
					style = "out",
				},
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
