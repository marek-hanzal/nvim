return {
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		opts = {
			stages = "static",
			timeout = 2500,
			max_width = 140,
			max_height = 18,
			background_colour = "#000000",
			render = "compact",
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
