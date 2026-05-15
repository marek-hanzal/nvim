return {
	{
		"nvim-mini/mini.move",
		version = "*",
		keys = {
			{
				"<M-Up>",
				function()
					require("mini.move").move_line("up")
				end,
				mode = "n",
				desc = "Move line up",
			},
			{
				"<M-Down>",
				function()
					require("mini.move").move_line("down")
				end,
				mode = "n",
				desc = "Move line down",
			},
			{
				"<M-Up>",
				function()
					require("mini.move").move_selection("up")
				end,
				mode = "x",
				desc = "Move selection up",
			},
			{
				"<M-Down>",
				function()
					require("mini.move").move_selection("down")
				end,
				mode = "x",
				desc = "Move selection down",
			},
		},

		opts = {
			mappings = {
				left = "",
				right = "",
				down = "",
				up = "",

				line_left = "",
				line_right = "",
				line_down = "",
				line_up = "",
			},
		},
	},
}
