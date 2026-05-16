return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			input = {
				enabled = true,
			},
			bigfile = {
				enabled = true,
				notify = true,
				size = 5 * 1024 * 1024,
				line_length = 1000,
			},
			bufdelete = {
				enabled = true,
			},
			lazygit = {
				enabled = true,
				configure = true,
			},
			styles = {
				lazygit = {
					width = 0,
					height = 0,
				},
			},
		},
		keys = {
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "LazyGit",
			},
			{
				"<leader>gl",
				function()
					Snacks.lazygit.log()
				end,
				desc = "Git log",
			},
			{
				"<leader>gL",
				function()
					Snacks.lazygit.log_file()
				end,
				desc = "Git file log",
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
					Snacks.bufdelete({ force = true })
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
		},
		config = function(_, opts)
			require("snacks").setup(opts)
		end,
	},
}
