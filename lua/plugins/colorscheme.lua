return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "night",
			on_highlights = function(highlights, colors)
				highlights.LspReferenceText = {
					bg = colors.fg_gutter,
					fg = colors.fg,
				}
				highlights.LspReferenceRead = {
					bg = colors.fg_gutter,
					fg = colors.fg,
				}
				highlights.LspReferenceWrite = {
					bg = colors.bg_search,
					fg = colors.black,
					bold = true,
				}
			end,
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight")
		end,
	},
}
