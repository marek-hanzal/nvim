local function line_width(bufnr)
	local textwidth = vim.bo[bufnr].textwidth

	return textwidth > 0 and textwidth or 80
end

local function line_ending(bufnr)
	return ({
		dos = "crlf",
		mac = "cr",
		unix = "lf",
	})[vim.bo[bufnr].fileformat]
end

return {
	{
		"stevearc/conform.nvim",
		cmd = {
			"ConformInfo",
		},
		opts = {
			notify_on_error = true,
			notify_no_formatters = false,

			formatters_by_ft = {
				lua = {
					"stylua",
				},

				javascript = {
					"biome",
				},
				javascriptreact = {
					"biome",
				},
				typescript = {
					"biome",
				},
				typescriptreact = {
					"biome",
				},

				json = {
					"biome",
				},
				jsonc = {
					"biome",
				},

				yaml = {
					"prettier",
				},
				html = {
					"prettier_html",
				},

				terraform = {
					"terraform_fmt",
				},
				tf = {
					"terraform_fmt",
				},
				["terraform-vars"] = {
					"terraform_fmt",
				},
				opentofu = {
					"tofu_fmt",
				},
				["opentofu-vars"] = {
					"tofu_fmt",
				},

				smarty = {
					"smarty_beautify",
				},

				php = {
					"pint",
					"php_cs_fixer",
					"phpcbf",
					stop_after_first = true,
				},

				sql = {
					"sql_formatter",
				},

				css = {
					"biome",
				},
				bash = {
					"shfmt",
				},
				sh = {
					"shfmt",
				},
			},
			formatters = {
				biome = {
					args = function(_, ctx)
						return {
							"format",
							"--stdin-file-path",
							"$FILENAME",
							"--indent-style",
							vim.bo[ctx.buf].expandtab and "space" or "tab",
							"--indent-width",
							tostring(ctx.shiftwidth),
							"--line-width",
							tostring(line_width(ctx.buf)),
							"--line-ending",
							line_ending(ctx.buf),
						}
					end,
				},

				prettier_html = {
					inherit = "prettier",
					append_args = function(_, ctx)
						return {
							"--tab-width",
							tostring(ctx.shiftwidth),
							"--use-tabs=" .. tostring(not vim.bo[ctx.buf].expandtab),
							"--print-width",
							tostring(line_width(ctx.buf)),
							"--end-of-line",
							line_ending(ctx.buf),
							"--embedded-language-formatting",
							"auto",
							"--html-whitespace-sensitivity",
							"css",
						}
					end,
				},

				tofu_fmt = {
					command = "tofu",
					args = {
						"fmt",
						"-no-color",
						"-",
					},
				},

				smarty_beautify = {
					command = require("util.local_tool").bin("js-beautify"),
					args = {
						"--type",
						"html",
						"--templating",
						"smarty",
						"--editorconfig",
						"--file",
						"-",
					},
				},
			},
		},
	},
}
