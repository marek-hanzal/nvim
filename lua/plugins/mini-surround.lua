return {
	{
		"nvim-mini/mini.surround",
		version = "*",
		event = "VeryLazy",

		opts = {
			n_lines = 500,

			mappings = {
				add = "gsa",
				delete = "gsd",
				find = "gsf",
				find_left = "gsF",
				highlight = "gsh",
				replace = "gsr",
				update_n_lines = "gsn",
			},
		},
	},
}
