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
