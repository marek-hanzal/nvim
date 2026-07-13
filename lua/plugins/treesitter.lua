local parsers = {
	"lua",
	"vim",
	"vimdoc",
	"query",

	"javascript",
	"typescript",
	"tsx",
	"php",

	"json",

	"html",
	"css",

	"markdown",
	"markdown_inline",

	"sql",
	"bash",

	"gitignore",
	"dockerfile",
	"hcl",
	"terraform",
	"yaml",
	"toml",
}

local filetypes = {
	"lua",
	"vim",
	"help",
	"query",

	"javascript",
	"javascriptreact",
	"typescript",
	"typescriptreact",
	"php",

	"json",
	"jsonc",

	"html",
	"css",

	"markdown",

	"sql",
	"bash",
	"sh",

	"gitignore",
	"dockerfile",
	"hcl",
	"terraform",
	"terraform-vars",
	"opentofu",
	"opentofu-vars",
	"yaml",
	"toml",
}

local parser_set = {}

for _, parser in ipairs(parsers) do
	parser_set[parser] = true
end

local function start_highlighting(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	local language = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)

	if not language or not parser_set[language] or not vim.treesitter.language.add(language) then
		return
	end

	vim.treesitter.start(bufnr, language)
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter_highlighting", { clear = true }),
				pattern = filetypes,
				callback = function(event)
					start_highlighting(event.buf)
				end,
			})

			local install = require("nvim-treesitter").install(parsers)

			install:await(function(err, success)
				if err or not success then
					vim.schedule(function()
						vim.notify("Treesitter parser installation failed", vim.log.levels.ERROR)
					end)
					return
				end

				vim.schedule(function()
					for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
						start_highlighting(bufnr)
					end
				end)
			end)
		end,
	},
}
