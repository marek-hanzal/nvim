return {
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader><leader>", "<cmd>FzfLua files<cr>", desc = "Find files" },
			{ "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
			{ "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Find buffers" },
			{ "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "Find help" },
			{ "<leader>fc", "<cmd>FzfLua commands<cr>", desc = "Find commands" },
			{ "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Find keymaps" },
			{ "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
			{ "<leader>f/", "<cmd>FzfLua lgrep_curbuf<cr>", desc = "Search current buffer" },
			{ "<leader>fR", "<cmd>FzfLua resume<cr>", desc = "Resume picker" },
		},
		opts = {
			winopts = {
				height = 0.85,
				width = 0.85,
				preview = {
					-- layout = "flex",
					hidden = true,
				},
			},
		},
	},
}
