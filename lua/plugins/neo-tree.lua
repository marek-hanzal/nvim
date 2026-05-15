return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		lazy = false,
		keys = {
			{
				"<leader>e",
				"<cmd>Neotree toggle filesystem reveal left<cr>",
				desc = "Toggle file explorer",
			},
			{
				"<leader>E",
				"<cmd>Neotree focus filesystem reveal left<cr>",
				desc = "Focus file explorer",
			},
		},
		opts = {
			close_if_last_window = true,

			popup_border_style = "rounded",

			enable_git_status = true,
			enable_diagnostics = false,

			filesystem = {
				bind_to_cwd = true,
				follow_current_file = {
					enabled = true,
					leave_dirs_open = true,
				},

				use_libuv_file_watcher = true,

				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = false,

					never_show = {},
				},
			},

			window = {
				position = "left",
				width = 42,
			},
		},
	},
}
