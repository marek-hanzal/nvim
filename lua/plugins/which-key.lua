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
				{ "<leader>f", group = "find" },
				{ "<leader>g", group = "git" },
				{ "<leader>w", desc = "Save file" },
				{ "<leader>q", desc = "Quit window" },
			})
		end,
	},
}
