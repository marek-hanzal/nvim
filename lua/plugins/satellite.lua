return {
	{
		"lewis6991/satellite.nvim",
		event = {
			"BufReadPost",
			"BufNewFile",
		},
		opts = {
			current_only = false,
			winblend = 0,
			handlers = {
				cursor = {
					enable = true,
				},
				search = {
					enable = true,
				},
				diagnostic = {
					enable = true,
				},
				gitsigns = {
					enable = true,
				},
			},
		},
	},
}
