return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter")

			local languages = {
				"lua",
				"vim",
				"vimdoc",

				"javascript",
				"typescript",
				"tsx",

				"json",

				"html",
				"css",

				"markdown",
				"markdown_inline",

				"sql",

				"gitignore",
				"dockerfile",
				"yaml",
				"toml",
			}

			treesitter.install(languages)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
				callback = function(event)
					local lang = vim.treesitter.language.get_lang(event.match)

					if not lang then
						return
					end

					local ok = pcall(vim.treesitter.start, event.buf, lang)

					if not ok then
						return
					end
				end,
			})
		end,
	},
}
