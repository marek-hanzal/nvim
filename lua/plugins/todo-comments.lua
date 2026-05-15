return {
	{
		"folke/todo-comments.nvim",
		event = {
			"BufReadPost",
			"BufNewFile",
		},
		cmd = {
			"TodoFzfLua",
			"TodoQuickFix",
			"TodoLocList",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{
				"<leader>xt",
				"<cmd>Trouble todo toggle<cr>",
				desc = "Todo comments",
			},
			{
				"<leader>tn",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next todo comment",
			},
			{
				"<leader>tp",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous todo comment",
			},
		},

		opts = {
			signs = true,

			keywords = {
				TODO = {
					icon = " ",
					color = "info",
				},
				NOTE = {
					icon = " ",
					color = "hint",
				},
			},

			highlight = {
				multiline = false,
				comments_only = true,
				keyword = "wide",
				after = "fg",
			},

			search = {
				command = "rg",
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
				},
			},
		},
	},
}
