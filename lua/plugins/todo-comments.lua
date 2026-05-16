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
			"ibhagwan/fzf-lua",
		},
		opts = {
			signs = true,
			merge_keywords = false,

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
