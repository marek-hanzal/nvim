return {
	{
		"folke/persistence.nvim",
		lazy = false,
		opts = {
			options = vim.opt.sessionoptions:get(),
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
