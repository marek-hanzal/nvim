local map = require("keymap.util").map

local M = {}

local project_lines_command = table.concat({
	"rg",
	"--column",
	"--line-number",
	"--no-heading",
	"--color=always",
	"--smart-case",
	"--hidden",
	"--no-ignore-vcs",
	"-e ^",
}, " ")

local project_fuzzy_change = table.concat({
	[[transform:if [ -z "$FZF_QUERY" ]; then]],
	[[printf 'reload-sync(true)\n';]],
	[[elif [ "${FZF_TOTAL_COUNT:-0}" -eq 0 ]; then]],
	string.format([[printf 'reload(%s)\n';]], project_lines_command),
	"fi",
}, " ")

local function open_project_tags()
	if vim.fn.findfile("tags", ".;") == "" then
		vim.notify("No tags file found; run :TagsGenerate first", vim.log.levels.WARN)
		return
	end

	require("fzf-lua").tags()
end

function M.setup()
	map("n", "<leader><leader>", function()
		require("fzf-lua").lsp_live_workspace_symbols()
	end, "Find workspace symbols")
	map("n", "<leader>ff", function()
		require("fzf-lua").files()
	end, "Find files and directories")
	map("n", "<leader>fD", function()
		require("ui.diagnostics").open_workspace()
	end, "Find workspace diagnostics")
	map("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", "Find buffers")
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
			cmd = "true",
			search = "",
			no_column_hide = true,
			keymap = {
				fzf = {
					change = project_fuzzy_change,
				},
			},
			fzf_opts = {
				["--delimiter"] = ":",
				["--nth"] = "4..",
			},
		})
	end, "Fuzzy search project lines")
	map("n", "<leader>ft", open_project_tags, "Find project tags")
	map("n", "<leader>fT", function()
		require("todo-comments.fzf").todo({
			keywords = {
				"TODO",
				"NOTE",
			},
			hidden = false,
			follow = false,
			prompt = "Search> ",
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
				title = " TODOs ",
				title_flags = false,
			},
		})
	end, "Find todo comments")
end

return M
