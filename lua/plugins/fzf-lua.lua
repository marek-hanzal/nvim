return {
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			winopts = {
				height = 0.85,
				width = 0.85,

				preview = {
					layout = "flex",
					hidden = false,
				},
			},

			files = {
				fd_opts = table.concat({
					"--color=never",
					"--type f",
					"--type l",
					"--hidden",
					"--no-ignore-vcs",
				}, " "),
			},

			grep = {
				rg_opts = table.concat({
					"--column",
					"--line-number",
					"--no-heading",
					"--color=always",
					"--smart-case",
					"--hidden",
					"--no-ignore-vcs",
				}, " "),
			},
		},
		config = function(_, opts)
			local fzf = require("fzf-lua")

			fzf.setup(opts)
			fzf.register_ui_select()
		end,
	},
}
