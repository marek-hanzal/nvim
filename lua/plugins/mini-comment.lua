return {
	{
		"nvim-mini/mini.comment",
		version = "*",
		event = "VeryLazy",

		opts = {
			options = {
				ignore_blank_line = false,
				start_of_line = false,
			},

			mappings = {
				comment = "gc",
				comment_line = "gcc",
				comment_visual = "gc",
				textobject = "gc",
			},
		},
	},
}
