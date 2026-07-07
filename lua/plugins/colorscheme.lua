return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "night",
			on_highlights = function(highlights, colors)
				highlights.NormalFloat = {
					bg = colors.bg_dark,
					fg = colors.fg,
				}
				highlights.FloatBorder = {
					bg = colors.bg_dark,
					fg = colors.blue,
				}
				highlights.LspFloatBorder = {
					bg = "#05070d",
					fg = colors.orange,
					bold = true,
				}
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
				highlights.SatelliteLspReferenceText = {
					fg = colors.blue1,
				}
				highlights.SatelliteLspReferenceRead = {
					fg = colors.teal,
				}
				highlights.SatelliteLspReferenceWrite = {
					fg = colors.orange,
				}
			end,
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight")
		end,
	},
}
