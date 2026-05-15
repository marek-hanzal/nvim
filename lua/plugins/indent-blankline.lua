return {
	{
		"lukas-reineke/indent-blankline.nvim",
		event = {
			"BufReadPost",
			"BufNewFile",
		},
		main = "ibl",
		opts = {
			indent = {
				char = "│",
			},
			scope = {
				enabled = true,
				show_start = false,
				show_end = false,
			},
			exclude = {
				filetypes = {
					-- "help",
					-- "lazy",
					-- "mason",
					-- "neo-tree",
					-- "noice",
					-- "notify",
					-- "oil",
					-- "qf",
					-- "Trouble",
				},
				buftypes = {
					"terminal",
					"nofile",
					"quickfix",
					"prompt",
				},
			},
		},
	},
}
