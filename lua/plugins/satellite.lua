return {
	{
		"lewis6991/satellite.nvim",
		event = {
			"BufReadPost",
			"BufNewFile",
		},
		config = function(_, opts)
			require("ui.satellite-lsp-references").register()
			require("satellite").setup(opts)
		end,
		opts = {
			current_only = false,
			winblend = 0,
			handlers = {
				cursor = {
					enable = true,
				},
				search = {
					enable = true,
				},
				diagnostic = {
					enable = true,
				},
				gitsigns = {
					enable = true,
				},
				lsp_references = {
					enable = true,
					overlap = true,
					priority = 25,
				},
			},
		},
	},
}
