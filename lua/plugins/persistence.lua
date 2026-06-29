return {
	{
		"folke/persistence.nvim",
		lazy = false,
		opts = {
			options = vim.opt.sessionoptions:get(),
		},
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Restore session",
			},
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore last session",
			},
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "Disable session save",
			},
		},
		config = function(_, opts)
			local persistence = require("persistence")

			persistence.setup(opts)

			vim.api.nvim_create_autocmd("VimEnter", {
				nested = true,
				callback = function()
					if vim.fn.argc() == 0 then
						persistence.load()
					end
				end,
			})
		end,
	},
}
