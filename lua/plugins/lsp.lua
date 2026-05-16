return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			vim.diagnostic.config({
				virtual_text = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = true,
				},
				signs = true,
				underline = true,
				update_in_insert = false,
			})
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp_attach", {
					clear = true,
				}),
				callback = require("keymap.c-code").on_lsp_attach,
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},

						diagnostics = {
							globals = {
								"vim",
							},
						},

						telemetry = {
							enable = false,
						},
					},
				},
			})

			vim.lsp.config("ts_ls", {})

			vim.lsp.config("intelephense", {})

			vim.lsp.config("jsonls", {
				init_options = {
					provideFormatter = false,
				},

				settings = {
					json = {
						schemas = require("schemastore").json.schemas(),
						validate = {
							enable = true,
						},
						format = {
							enable = false,
						},
					},
				},
			})

			vim.lsp.config("taplo", {})

			vim.lsp.config("tailwindcss", {})

			vim.lsp.config("yamlls", {
				settings = {
					redhat = {
						telemetry = {
							enabled = false,
						},
					},

					yaml = {
						format = {
							enable = false,
						},
						validate = true,
						schemaStore = {
							enable = false,
							url = "",
						},

						schemas = require("schemastore").yaml.schemas(),
					},
				},
			})

			vim.lsp.config("gh_actions_ls", {})

			vim.lsp.enable({
				"lua_ls",
				"ts_ls",
				"intelephense",
				"jsonls",
				"taplo",
				"tailwindcss",
				"yamlls",
				"gh_actions_ls",
			})
		end,
	},
}
