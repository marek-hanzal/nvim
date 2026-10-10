return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"mason-org/mason.nvim",
			"saghen/blink.cmp",
			"antosha417/nvim-lsp-file-operations",
			"b0o/schemastore.nvim",
		},
		config = function()
			local lsp_float = require("ui.lsp_float")
			local capabilities =
				require("blink.cmp").get_lsp_capabilities(require("lsp-file-operations").default_capabilities(), true)

			vim.diagnostic.config({
				virtual_text = false,
				severity_sort = true,
				float = lsp_float.config({
					source = true,
				}),
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

			vim.lsp.config("*", {
				capabilities = capabilities,
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

			vim.lsp.config("biome", {})

			vim.lsp.config("ts_ls", {})

			vim.lsp.config("pyright", {
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							useLibraryCodeForTypes = true,
						},
					},
				},
			})

			vim.lsp.config("intelephense", {
				settings = {
					intelephense = {
						telemetry = {
							enabled = false,
						},
					},
				},
			})

			vim.lsp.config("smarty_ls", {
				cmd = {
					require("util.local_tool").bin("smarty-language-server"),
					"--stdio",
				},
				filetypes = {
					"smarty",
				},
				root_markers = {
					"composer.json",
					".git",
				},
				settings = {
					smarty = {
						pluginDirs = {},
					},
				},
			})

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

			vim.lsp.config("bashls", {
				settings = {
					bashIde = {
						-- Avoid duplicate diagnostics; shellcheck is run via nvim-lint.
						shellcheckPath = "",
					},
				},
			})

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

			vim.lsp.config("terraformls", {})

			vim.lsp.config("tofu_ls", {
				filetypes = {
					"opentofu",
					"opentofu-vars",
				},
			})

			vim.lsp.config("tflint", {})

			vim.lsp.enable({
				"biome",
				"lua_ls",
				"ts_ls",
				"pyright",
				"intelephense",
				"smarty_ls",
				"jsonls",
				"taplo",
				"tailwindcss",
				"bashls",
				"yamlls",
				"gh_actions_ls",
				"terraformls",
				"tofu_ls",
				"tflint",
			})
		end,
	},
}
