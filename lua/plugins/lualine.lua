return {
	{
		"nvim-lualine/lualine.nvim",

		event = "VeryLazy",

		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},

		opts = {
			options = {
				theme = "auto",

				globalstatus = true,

				component_separators = {
					left = "",
					right = "",
				},

				section_separators = {
					left = "",
					right = "",
				},

				disabled_filetypes = {
					statusline = {
						"neo-tree",
						"oil",
					},
				},
			},

			sections = {
				lualine_a = {
					"mode",
				},

				lualine_b = {
					"branch",
					"diff",
				},

				lualine_c = {
					{
						"filename",
						path = 1,
					},
				},

				lualine_x = {
					{
						"diagnostics",
						sources = {
							"nvim_diagnostic",
						},
					},
					"filetype",
				},

				lualine_y = {
					"progress",
				},

				lualine_z = {
					"location",
				},
			},

			extensions = {
				"lazy",
				"mason",
				"quickfix",
				"neo-tree",
			},
		},
	},
}
