local function show_completion()
	require("blink.cmp").show()
end

return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		event = {
			"InsertEnter",
			"CmdlineEnter",
		},
		init = function()
			for _, key in ipairs({ "<M-Space>", "<Char-160>" }) do
				vim.keymap.set("i", key, show_completion, {
					desc = "Show completion",
					silent = true,
				})
			end
		end,
		opts = {
			keymap = {
				preset = "enter",
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
