return {
	{
		"sindrets/diffview.nvim",
		cmd = {
			"DiffviewOpen",
			"DiffviewClose",
			"DiffviewToggleFiles",
			"DiffviewFocusFiles",
			"DiffviewFileHistory",
			"DiffviewRefresh",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{
				"<leader>gd",
				"<cmd>DiffviewOpen<cr>",
				desc = "Git diff",
			},
			{
				"<leader>gD",
				"<cmd>DiffviewOpen --staged<cr>",
				desc = "Git staged diff",
			},
			{
				"<leader>gh",
				"<cmd>DiffviewFileHistory %<cr>",
				desc = "Git file history",
			},
			{
				"<leader>gH",
				"<cmd>DiffviewFileHistory<cr>",
				desc = "Git repo history",
			},
			{
				"<leader>gx",
				"<cmd>DiffviewClose<cr>",
				desc = "Close git diff",
			},
		},
		opts = {
			enhanced_diff_hl = true,

			view = {
				default = {
					layout = "diff2_horizontal",
				},
				merge_tool = {
					layout = "diff3_horizontal",
				},
				file_history = {
					layout = "diff2_horizontal",
				},
			},
			file_panel = {
				listing_style = "tree",
				tree_options = {
					flatten_dirs = true,
					folder_statuses = "only_folded",
				},
			},
		},
	},
}
