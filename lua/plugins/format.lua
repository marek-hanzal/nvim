return {
	{
		"stevearc/conform.nvim",
		cmd = {
			"ConformInfo",
		},
		opts = {
			notify_on_error = true,
			notify_no_formatters = false,

			formatters_by_ft = {
				lua = {
					"stylua",
				},

				javascript = {
					"biome",
				},
				javascriptreact = {
					"biome",
				},
				typescript = {
					"biome",
				},
				typescriptreact = {
					"biome",
				},

				json = {
					"biome",
				},
				jsonc = {
					"biome",
				},

				css = {
					"biome",
				},
			},
		},
	},
}
