return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			input = {
				enabled = true,
			},
			picker = {
				enabled = true,

				sources = {
					explorer = {
						hidden = true,
						ignored = false,
						follow_file = true,
						focus = "list",
						tree = true,
						layout = {
							preset = "sidebar",
							layout = {
								position = "left",
								width = 42,
							},
						},
						win = {
							list = {
								keys = {
									["<CR>"] = "confirm",
									["h"] = "explorer_close",
									["a"] = "explorer_add",
									["d"] = "explorer_del",
									["r"] = "explorer_rename",
									["c"] = "explorer_copy",
									["m"] = "explorer_move",
									["y"] = "explorer_yank",
									["p"] = "explorer_paste",
									["u"] = "explorer_update",
								},
							},
						},
					},
				},
			},
			explorer = {
				enabled = true,
				replace_netrw = false,
			},
			indent = {
				enabled = true,

				indent = {
					enabled = true,
					char = "│",
					only_current = true,
					only_scope = false,
				},

				scope = {
					enabled = true,
					char = "│",
					only_current = true,
				},

				chunk = {
					enabled = false,
				},

				animate = {
					enabled = true,
					style = "out",
					easing = "linear",
					duration = {
						step = 15,
						total = 180,
					},
				},

				filter = function(buffer)
					local filetype = vim.bo[buffer].filetype

					if vim.bo[buffer].buftype ~= "" then
						return false
					end

					return not vim.tbl_contains({
						"help",
						"lazy",
						"mason",
						"neo-tree",
						"noice",
						"notify",
						"oil",
						"qf",
						"Trouble",
					}, filetype)
				end,
			},
		},
		keys = {
			{
				"<leader><leader>",
				function()
					Snacks.picker.files()
				end,
				desc = "Find files",
			},
			{
				"<leader>fc",
				function()
					Snacks.picker.commands()
				end,
				desc = "Find commands",
			},
			{
				"<leader>e",
				function()
					Snacks.explorer()
				end,
				desc = "Explorer",
			},
			{
				"<leader>E",
				function()
					Snacks.explorer({
						cwd = vim.fn.expand("%:p:h"),
					})
				end,
				desc = "Explorer current file dir",
			},
		},
	},
}
