return {
	{
		"mfussenegger/nvim-lint",
		event = {
			"BufReadPost",
			"BufNewFile",
		},
		keys = {
			{
				"<leader>cl",
				function()
					require("lint").try_lint()
				end,
				desc = "Lint code",
			},
		},
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = {
					"biomejs",
				},
				javascriptreact = {
					"biomejs",
				},
				typescript = {
					"biomejs",
				},
				typescriptreact = {
					"biomejs",
				},

				json = {
					"biomejs",
				},
				jsonc = {
					"biomejs",
				},

				css = {
					"biomejs",
				},

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
