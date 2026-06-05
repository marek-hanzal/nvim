return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

			local lsp_float_border = {
				{ "╭", "LspFloatBorder" },
				{ "─", "LspFloatBorder" },
				{ "╮", "LspFloatBorder" },
				{ "│", "LspFloatBorder" },
				{ "╯", "LspFloatBorder" },
				{ "─", "LspFloatBorder" },
				{ "╰", "LspFloatBorder" },
				{ "│", "LspFloatBorder" },
			}

			local function lsp_float_config()
				return {
					border = lsp_float_border,
					focusable = true,
					max_width = math.floor(vim.o.columns * 0.6),
					max_height = math.floor(vim.o.lines * 0.5),
					zindex = 80,
				}
			end

			local open_floating_preview = vim.lsp.util.open_floating_preview
			vim.lsp.util.open_floating_preview = function(contents, syntax, config)
				local bufnr, winid = open_floating_preview(
					contents,
					syntax,
					vim.tbl_deep_extend("force", lsp_float_config(), config or {})
				)

				if winid and vim.api.nvim_win_is_valid(winid) then
					vim.wo[winid].winblend = 0
					vim.wo[winid].winhighlight = table.concat({
						"NormalFloat:LspFloatNormal",
						"FloatBorder:LspFloatBorder",
						"FloatTitle:LspFloatTitle",
					}, ",")
				end

				return bufnr, winid
			end

			local hover_handler = vim.lsp.handlers.hover
			vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
				config = vim.tbl_deep_extend("force", lsp_float_config(), config or {})
				return hover_handler(err, result, ctx, config)
			end

			local signature_help_handler = vim.lsp.handlers.signature_help
			vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
				config = vim.tbl_deep_extend("force", lsp_float_config(), config or {})
				return signature_help_handler(err, result, ctx, config)
			end

			vim.diagnostic.config({
				virtual_text = false,
				severity_sort = true,
				float = vim.tbl_deep_extend("force", lsp_float_config(), {
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
				"biome",
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
