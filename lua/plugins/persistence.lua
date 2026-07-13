return {
	{
		"folke/persistence.nvim",
		lazy = false,
		cond = function()
			return not vim.list_contains(vim.v.argv, "--headless")
		end,
		opts = {
			options = vim.opt.sessionoptions:get(),
		},
		config = function(_, opts)
			local persistence = require("persistence")

			persistence.setup(opts)
			require("util.session").setup(persistence)
		end,
	},
}
