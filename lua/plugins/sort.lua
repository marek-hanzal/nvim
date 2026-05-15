return {
	{
		"sQVe/sort.nvim",
		cmd = {
			"Sort",
		},
		keys = {
			{
				"<leader>ls",
				":Sort<cr>",
				mode = "x",
				desc = "Sort selection",
			},
			{
				"<leader>lS",
				":Sort!<cr>",
				mode = "x",
				desc = "Sort selection reverse",
			},
			{
				"<leader>lu",
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
