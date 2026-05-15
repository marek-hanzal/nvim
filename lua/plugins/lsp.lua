return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			vim.diagnostic.config({
				virtual_text = true,
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

				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)

					if client then
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
					end

					local function map(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, {
							buffer = event.buf,
							desc = desc,
						})
					end

					map("n", "gd", vim.lsp.buf.definition, "Goto definition")
					map("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
					map("n", "gi", vim.lsp.buf.implementation, "Goto implementation")
					map("n", "gr", vim.lsp.buf.references, "References")

					map("n", "K", vim.lsp.buf.hover, "Hover")
					map("n", "<leader>cs", vim.lsp.buf.signature_help, "Signature help")

					map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
					map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
				end,
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

						workspace = {
							library = {
								vim.env.VIMRUNTIME,
							},
						},

						telemetry = {
							enable = false,
						},
					},
				},
			})

			vim.lsp.config("ts_ls", {})

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
				"jsonls",
				"taplo",
				"tailwindcss",
				"yamlls",
				"gh_actions_ls",
			})
		end,
	},
}
