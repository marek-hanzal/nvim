return {
	{
		"saghen/blink.cmp",
		version = "1.*",
        event = {
			"InsertEnter",
			"CmdlineEnter",
		},
		opts = {
			keymap = {
				preset = "enter",
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 250,
				},

				ghost_text = {
					enabled = false,
				},
			},

			sources = {
				default = {
					"lsp",
					"path",
					-- "snippets",
					"buffer",
				},
			},

			signature = {
				enabled = true,
			},
		},
	},
}
