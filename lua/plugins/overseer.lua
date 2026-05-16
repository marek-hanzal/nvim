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
			component_aliases = {
				default = {
					"on_exit_set_status",
					"on_complete_notify",
					{ "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
					{
						"open_output",
						on_start = "always",
						direction = "dock",
						focus = true,
					},
				},
			},
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
