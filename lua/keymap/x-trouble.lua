local map = require("keymap.util").map

local M = {}

function M.setup()
	map("n", "<leader>xx", function()
		require("fzf-lua").diagnostics_workspace({
			sort = true,
			previewer = false,
		})
	end, "Diagnostics")
	map("n", "<leader>xb", function()
		require("fzf-lua").diagnostics_document({
			sort = true,
			previewer = false,
			fzf_opts = {
				["--no-input"] = true,
			},
		})
	end, "Buffer diagnostics")
	map("n", "<leader>xq", function()
		require("fzf-lua").quickfix({
			previewer = false,
		})
	end, "Quickfix")
	map("n", "<leader>xl", function()
		require("fzf-lua").loclist({
			previewer = false,
		})
	end, "Location list")
	map("n", "<leader>xs", function()
		require("fzf-lua").lsp_document_symbols({
			previewer = false,
		})
	end, "Symbols")
	map("n", "<leader>xt", function()
		require("todo-comments.fzf").todo({
			keywords = {
				"TODO",
				"NOTE",
			},
			hidden = false,
			follow = false,
			prompt = "Todo> ",
			previewer = true,
			rg_opts = table.concat({
				"--column",
				"--line-number",
				"--no-heading",
				"--color=always",
				"--smart-case",
				"--max-columns=4096",
				"-e",
			}, " "),
			winopts = {
				title = " TODO List ",
				title_flags = false,
			},
		})
	end, "Todo comments")
end

return M
