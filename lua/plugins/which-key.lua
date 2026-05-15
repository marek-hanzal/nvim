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
				{ "<leader>x", group = "trouble" },
				{ "<leader>d", group = "database" },
				{ "<leader>t", group = "todo" },
				{ "<leader>w", desc = "Save file" },
				{ "<leader>q", desc = "Quit window" },
			})
		end,
	},
}
