return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			local wk = require("which-key")

			wk.setup(opts)

			wk.add({
				{ "<leader>c", group = "code" },
				{ "<leader>b", group = "buffer" },
				{ "<leader>f", group = "find/pickers" },
				{ "<leader>j", group = "jump" },
				{ "<leader>g", group = "git" },
				{ "<leader>r", group = "run" },
				{ "<leader>m", group = "markdown" },
				{ "<leader>h", group = "http" },
				{ "<leader>l", group = "line" },
				{ "<leader>d", group = "database" },
				{ "<leader>t", group = "todo" },
				{ "<leader>s", group = "search/sort" },
			})
		end,
	},
}
