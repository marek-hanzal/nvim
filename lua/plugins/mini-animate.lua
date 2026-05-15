return {
	{
		"nvim-mini/mini.animate",
		version = "*",

		event = "VeryLazy",

		opts = function()
			local animate = require("mini.animate")

			return {
				cursor = {
					enable = false,
				},

				scroll = {
					enable = true,
					timing = animate.gen_timing.linear({
						duration = 120,
						unit = "total",
					}),
				},

				resize = {
					enable = false,
				},

				open = {
					enable = false,
				},

				close = {
					enable = false,
				},
			}
		end,

		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("mini_animate_disable", {
					clear = true,
				}),

				pattern = {
					"lazy",
					"mason",
					"neo-tree",
					"oil",
					"qf",
					"Trouble",
				},

				callback = function()
					vim.b.minianimate_disable = true
				end,
			})
		end,
	},
}
