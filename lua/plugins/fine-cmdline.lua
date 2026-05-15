return {
	{
		"VonHeikemen/fine-cmdline.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		cmd = {
			"FineCmdline",
		},
		keys = {
			{
				":",
				"<cmd>FineCmdline<cr>",
				mode = "n",
				desc = "Command line",
			},
		},
		opts = {
			cmdline = {
				enable_keymaps = true,
				smart_history = true,
				prompt = ": ",
			},
			popup = {
				position = {
					row = "10%",
					col = "50%",
				},
				size = {
					width = "60%",
				},
				border = {
					style = "rounded",
				},
				win_options = {
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
				},
			},
		},
	},
}
