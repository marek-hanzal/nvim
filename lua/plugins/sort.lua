return {
	{
		"sQVe/sort.nvim",
		cmd = {
			"Sort",
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
