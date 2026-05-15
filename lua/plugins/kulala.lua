return {
	{
		"mistweaverco/kulala.nvim",
		ft = {
			"http",
			"rest",
		},
		keys = {
			{
				"<leader>hr",
				function()
					require("kulala").run()
				end,
				desc = "Run HTTP request",
			},
			{
				"<leader>ha",
				function()
					require("kulala").run_all()
				end,
				desc = "Run all HTTP requests",
			},
			{
				"<leader>ht",
				function()
					require("kulala").toggle_view()
				end,
				desc = "Toggle HTTP response",
			},
			{
				"<leader>hi",
				function()
					require("kulala").inspect()
				end,
				desc = "Inspect HTTP request",
			},
		},

		opts = {},
	},
}
