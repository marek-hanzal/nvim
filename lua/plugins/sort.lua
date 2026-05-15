return {
	{
		"sQVe/sort.nvim",
		cmd = {
			"Sort",
		},
		keys = {
			{
				"<leader>ss",
				":Sort<cr>",
				mode = "x",
				desc = "Sort selection",
			},
			{
				"<leader>sS",
				":Sort!<cr>",
				mode = "x",
				desc = "Sort selection reverse",
			},
			{
				"<leader>su",
				":Sort u<cr>",
				mode = "x",
				desc = "Sort selection unique",
			},
		},
		opts = {
			natural_sort = true,
			ignore_case = false,
			unique = false,
			mappings = {
				operator = "go",
				textobject = {
					inner = "io",
					around = "ao",
				},
				motion = {
					next_delimiter = "]o",
					prev_delimiter = "[o",
				},
			},
		},
	},
}
