local cleanup_kinds_by_ft = {
	javascript = {
		"source.removeUnusedImports.ts",
		"source.organizeImports.ts",
	},
	javascriptreact = {
		"source.removeUnusedImports.ts",
		"source.organizeImports.ts",
	},
	typescript = {
		"source.removeUnusedImports.ts",
		"source.organizeImports.ts",
	},
	typescriptreact = {
		"source.removeUnusedImports.ts",
		"source.organizeImports.ts",
	},
}

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

				smarty = {
					"smarty_beautify",
				},

				sql = {
					"sql_formatter",
				},

				css = {
					"biome",
				},
			},
			formatters = {
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
