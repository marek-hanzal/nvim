return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			filter = function(mapping)
				return mapping.desc and mapping.desc ~= ""
			end,
		},
		config = function(_, opts)
			local wk = require("which-key")

			wk.setup(opts)

			wk.add({
				{ "<leader>", group = "leader", mode = { "n", "x" } },
				{ "<leader>b", group = "buffers", mode = { "n", "x" } },
				{ "<leader>c", group = "code", mode = { "n", "x" } },
				{ "<leader>f", group = "find/pickers", mode = { "n", "x" } },
				{ "<leader>g", group = "git", mode = { "n", "x" } },
				{ "<leader>l", group = "lines", mode = { "n", "x" } },
				{ "<leader>m", group = "markdown", mode = { "n", "x" } },
				{ "<leader>q", group = "sessions", mode = { "n", "x" } },
				{ "<leader>t", group = "tools", mode = { "n", "x" } },

				{ "g", group = "goto/operators", mode = { "n", "x", "o" } },
				{ "gr", group = "LSP", mode = { "n", "x" } },
				{ "[", group = "previous", mode = { "n", "x" } },
				{ "]", group = "next", mode = { "n", "x" } },
				{ "z", group = "folds/spelling", mode = { "n", "x" } },

				{
					real = true,

					{ "gO", desc = "Document symbols" },
					{ "gra", desc = "Code action", mode = { "n", "x" } },
					{ "gri", desc = "Go to implementation" },
					{ "grn", desc = "Rename symbol" },
					{ "grr", desc = "Find references" },
					{ "grt", desc = "Go to type definition" },
					{ "grx", desc = "Run code lens" },

					{ "[a", desc = "Previous argument" },
					{ "]a", desc = "Next argument" },
					{ "[A", desc = "First argument" },
					{ "]A", desc = "Last argument" },
					{ "[b", desc = "Previous buffer" },
					{ "]b", desc = "Next buffer" },
					{ "[B", desc = "First buffer" },
					{ "]B", desc = "Last buffer" },
					{ "[d", desc = "Previous diagnostic" },
					{ "]d", desc = "Next diagnostic" },
					{ "[D", desc = "First diagnostic" },
					{ "]D", desc = "Last diagnostic" },
					{ "[l", desc = "Previous location" },
					{ "]l", desc = "Next location" },
					{ "[L", desc = "First location" },
					{ "]L", desc = "Last location" },
					{ "[q", desc = "Previous quickfix item" },
					{ "]q", desc = "Next quickfix item" },
					{ "[Q", desc = "First quickfix item" },
					{ "]Q", desc = "Last quickfix item" },
					{ "[t", desc = "Previous tag" },
					{ "]t", desc = "Next tag" },
					{ "[T", desc = "First tag" },
					{ "]T", desc = "Last tag" },
					{ "[<C-L>", desc = "Previous location-list file" },
					{ "]<C-L>", desc = "Next location-list file" },
					{ "[<C-Q>", desc = "Previous quickfix file" },
					{ "]<C-Q>", desc = "Next quickfix file" },
					{ "[<C-T>", desc = "Preview previous tag" },
					{ "]<C-T>", desc = "Preview next tag" },

					{ "<C-L>", desc = "Redraw and clear search" },
					{ "<C-S>", desc = "Signature help", mode = "s" },
					{ "&", desc = "Repeat last substitute" },
					{ "Y", desc = "Yank to end of line" },
					{ "*", desc = "Search selection forward", mode = "x" },
					{ "#", desc = "Search selection backward", mode = "x" },
					{ "@", desc = "Run register on selected lines", mode = "x" },
					{ "Q", desc = "Repeat register on selected lines", mode = "x" },
				},
			})
		end,
	},
}
