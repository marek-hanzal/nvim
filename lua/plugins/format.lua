return {
	{
		"stevearc/conform.nvim",
		cmd = {
			"ConformInfo",
		},
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({
						async = true,
						lsp_format = "fallback",
					})
				end,
				mode = {
					"n",
					"x",
				},
				desc = "Format code",
			},
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
