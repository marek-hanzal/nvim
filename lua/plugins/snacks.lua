return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			input = {
				enabled = true,
			},
			bufdelete = {
				enabled = true,
			},
			bigfile = {
				enabled = true,
				notify = true,
				size = 5 * 1024 * 1024,
				line_length = 1000,
			},
			picker = {
				enabled = true,
				hidden = true,
				ignored = true,

				sources = {
					explorer = {
						hidden = true,
						ignored = false,
						excluded = {},
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
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete buffer",
			},
			{
				"<leader>bD",
				function()
					Snacks.bufdelete({
						force = true,
					})
				end,
				desc = "Force delete buffer",
			},
			{
				"<leader>bo",
				function()
					Snacks.bufdelete.other({
						filter = function(buffer)
							return vim.bo[buffer].buflisted and vim.bo[buffer].buftype == ""
						end,
					})
				end,
				desc = "Delete other buffers",
			},
			{
				"<leader>bO",
				function()
					Snacks.bufdelete.other({
						force = true,
						filter = function(buffer)
							return vim.bo[buffer].buflisted and vim.bo[buffer].buftype == ""
						end,
					})
				end,
				desc = "Force delete other buffers",
			},
		},
	},
}
