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
				{ "<leader>f", group = "find" },
				{ "<leader>j", group = "jump" },
				{ "<leader>g", group = "git" },
				{ "<leader>r", group = "run" },
				{ "<leader>m", group = "markdown" },
                { "<leader>l", group = "line" },
				{ "<leader>x", group = "trouble" },
				{ "<leader>d", group = "database" },
				{ "<leader>t", group = "todo" },
                { "<leader>s", group = "search/sort" },
				{ "<leader>w", desc = "Save file" },
				{ "<leader>q", desc = "Quit window" },
			})
		end,
	},
}
