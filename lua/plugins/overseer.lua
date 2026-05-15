return {
	{
		"stevearc/overseer.nvim",
		cmd = {
			"OverseerOpen",
			"OverseerClose",
			"OverseerToggle",
			"OverseerRun",
			"OverseerTaskAction",
			"OverseerShell",
		},
		keys = {
			{
				"<leader>rr",
				"<cmd>OverseerRun<cr>",
				desc = "Run task",
			},
			{
				"<leader>rt",
				"<cmd>OverseerToggle right<cr>",
				desc = "Toggle tasks",
			},
		},
		opts = {
			dap = false,
			task_list = {
				direction = "right",
				min_width = 40,
				max_width = 80,
				default_detail = 1,

				bindings = {
					["q"] = "Close",
					["<CR>"] = "RunAction",
					["o"] = "Open",
					["r"] = "Restart",
					["s"] = "Stop",
					["d"] = "Dispose",
				},
			},
		},
	},
}
