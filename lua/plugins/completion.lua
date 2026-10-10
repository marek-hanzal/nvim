return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		dependencies = {
			"L3MON4D3/LuaSnip",
		},
		event = {
			"InsertEnter",
			"CmdlineEnter",
		},
		opts = {
			keymap = {
				preset = "enter",
				-- Snippet navigation belongs to keymap/core.lua, including Select mode.
				["<Tab>"] = false,
				["<S-Tab>"] = false,
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
					"buffer",
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
