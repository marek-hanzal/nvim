return {
	{
		"mason-org/mason.nvim",
		lazy = false,
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		opts = {
			PATH = "prepend",

			ui = {
				border = "rounded",
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		lazy = false,
		opts = {
			ensure_installed = {
				"lua-language-server",
				"typescript-language-server",
				"phpactor",
				"json-lsp",
				"taplo",
				"tailwindcss-language-server",
				"yaml-language-server",
				"gh-actions-language-server",
				"terraform-ls",
				"stylua",
				"biome",
				"bash-language-server",
				"prettier",
				"sql-formatter",
				"markdownlint-cli2",
				"tflint",
			},
			run_on_start = true,
			start_delay = 3000,
			debounce_hours = 12,
		},
	},
}
