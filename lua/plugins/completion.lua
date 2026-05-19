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

				["<M-Space>"] = {
					"show",
					"show_documentation",
					"hide_documentation",
				},
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				menu = {
					auto_show = false,
				},

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
					"snippets",
					"buffer",
				},

				per_filetype = {
					sql = {
						"snippets",
						"dadbod",
						"buffer",
					},
					mysql = {
						"snippets",
						"dadbod",
						"buffer",
					},
					plsql = {
						"snippets",
						"dadbod",
						"buffer",
					},
				},

				providers = {
					dadbod = {
						name = "Dadbod",
						module = "vim_dadbod_completion.blink",
					},
				},
			},

			signature = {
				enabled = true,
			},

			snippets = {
				preset = "luasnip",
			},
		},
	},
}
