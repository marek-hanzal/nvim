return {
	{
		"rcarriga/nvim-notify",
		lazy = false,
		opts = {
			stages = "static",
			timeout = 8000,
			merge_duplicates = false,
			max_width = function()
				return math.max(60, math.floor(vim.o.columns * 0.45))
			end,
			max_height = 18,
			background_colour = "#000000",
			render = "wrapped-compact",
			top_down = false,
			fps = 30,
			icons = {
				ERROR = "",
				WARN = "",
				INFO = "",
				DEBUG = "",
				TRACE = "✎",
			},
		},
		config = function(_, opts)
			local notify = require("notify")
			notify.setup(opts)
			vim.notify = notify
		end,
	},
}
