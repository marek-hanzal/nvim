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
				"intelephense",
				"json-lsp",
				"taplo",
				"tailwindcss-language-server",
				"yaml-language-server",
				"gh-actions-language-server",
				"stylua",
				"biome",
				"markdownlint-cli2",
			},
			run_on_start = true,
			start_delay = 3000,
			debounce_hours = 12,
		},
	},
}
