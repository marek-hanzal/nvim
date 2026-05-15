return {
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader><leader>", "<cmd>FzfLua files<cr>", desc = "Find files" },
			{ "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Find keymaps" },
			{ "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent files" },
			{ "<leader>fR", "<cmd>FzfLua resume<cr>", desc = "Resume picker" },

			{ "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Find document symbols" },
			{ "<leader>fS", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "Find workspace symbols" },
			{
				"/",
				"<cmd>FzfLua blines<cr>",
				desc = "Fuzzy search buffer lines",
			},
			{
				"<leader>/",
				"/",
				desc = "Native search",
			},
			{
				"<leader>fa",
				function()
					require("fzf-lua").grep({
						search = "",
						prompt = "Project fuzzy> ",
					})
				end,
				desc = "Fuzzy search project lines",
			},
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
