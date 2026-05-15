return {
	{
		"nvim-mini/mini.indentscope",
		version = "*",
		event = {
			"BufReadPost",
			"BufNewFile",
		},
		opts = function()
			local indentscope = require("mini.indentscope")

			return {
				symbol = "│",

				options = {
					try_as_border = true,
				},

				draw = {
					delay = 50,

					animation = indentscope.gen_animation.quadratic({
						easing = "out",
						duration = 120,
						unit = "total",
					}),
				},
			}
		end,

		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("mini_indentscope_disable", {
					clear = true,
				}),

				pattern = {
					"help",
					"lazy",
					"mason",
					"neo-tree",
					"noice",
					"notify",
					"oil",
					"qf",
					"Trouble",
				},

				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},
}
