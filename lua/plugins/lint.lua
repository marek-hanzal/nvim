return {
	{
		"mfussenegger/nvim-lint",
		event = {
			"BufReadPost",
			"BufNewFile",
		},
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				markdown = {
					"markdownlint-cli2",
				},
			}

			local lint_group = vim.api.nvim_create_augroup("lint", {
				clear = true,
			})

			vim.api.nvim_create_autocmd({
				"BufWritePost",
				"InsertLeave",
			}, {
				group = lint_group,
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
