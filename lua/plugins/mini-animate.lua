return {
	{
		"nvim-mini/mini.animate",
		version = "*",

		event = "VeryLazy",

		opts = function()
			local animate = require("mini.animate")

			return {
				cursor = {
					enable = true,
				},

				scroll = {
					enable = true,
					timing = animate.gen_timing.linear({
						duration = 120,
						unit = "total",
					}),
				},

				resize = {
					enable = true,
					timing = animate.gen_timing.linear({
						duration = 80,
						unit = "total",
					}),
				},

				open = {
					enable = true,
					timing = animate.gen_timing.linear({
						duration = 80,
						unit = "total",
					}),
				},

				close = {
					enable = true,
					timing = animate.gen_timing.linear({
						duration = 80,
						unit = "total",
					}),
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
