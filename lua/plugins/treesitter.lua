return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"lua",
				"vim",
				"vimdoc",
				"query",

				"javascript",
				"typescript",
				"tsx",

				"json",

				"html",
				"css",

				"markdown",
				"markdown_inline",

				"sql",

				"gitignore",
				"dockerfile",
				"yaml",
				"toml",
			},
			auto_install = true,
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
		},
		config = function(_, opts)
			require("nvim-treesitter").setup(opts)
		end,
	},
}
