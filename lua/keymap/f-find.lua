local map = require("keymap.util").map

local M = {}

function M.setup()
	map("n", "<leader><leader>", function()
		require("fzf-lua").files()
	end, "Find files and directories")
	map("n", "<leader>fd", function()
		require("fzf-lua").diagnostics_document({
			sort = true,
			previewer = false,
			fzf_opts = {
				["--no-input"] = true,
			},
		})
	end, "Find buffer diagnostics")
	map("n", "<leader>fD", function()
		require("fzf-lua").diagnostics_workspace({
			sort = true,
			previewer = false,
		})
	end, "Find workspace diagnostics")
	map("n", "<leader>fk", "<cmd>FzfLua keymaps<cr>", "Find keymaps")
	map("n", "<leader>fl", function()
		require("fzf-lua").loclist({
			previewer = false,
		})
	end, "Find location list")
	map("n", "<leader>fq", function()
		require("fzf-lua").quickfix({
			previewer = false,
		})
	end, "Find quickfix list")
	map("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", "Recent files")
	map("n", "<leader>fR", "<cmd>FzfLua resume<cr>", "Resume picker")
	map("n", "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", "Find document symbols")
	map("n", "<leader>fS", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", "Find workspace symbols")
	map("n", "/", "<cmd>FzfLua blines<cr>", "Fuzzy search buffer lines")
	map("n", "<leader>/", "/", "Native search")
	map("n", "<leader>fa", function()
		require("fzf-lua").grep({
			search = "",
			prompt = "Project fuzzy> ",
		})
	end, "Fuzzy search project lines")
	map("n", "<leader>ft", function()
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
	end, "Find todo comments")
end

return M
