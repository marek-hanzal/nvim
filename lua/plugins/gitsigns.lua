return {
	{
		"lewis6991/gitsigns.nvim",
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		opts = {
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},

			signs_staged_enable = true,

			signcolumn = true,
			numhl = false,
			linehl = false,
			word_diff = false,

			current_line_blame = false,

			preview_config = {
				border = "rounded",
			},

			on_attach = function(buffer)
				local gitsigns = require("gitsigns")

				local function map(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, {
						buffer = buffer,
						desc = desc,
					})
				end

				map("n", "<leader>gn", function()
					gitsigns.nav_hunk("next")
				end, "Next git hunk")

				map("n", "<leader>gN", function()
					gitsigns.nav_hunk("prev")
				end, "Previous git hunk")

				map("n", "<leader>gp", gitsigns.preview_hunk, "Preview git hunk")
				map("n", "<leader>gi", gitsigns.preview_hunk_inline, "Preview git hunk inline")

				map("n", "<leader>gs", gitsigns.stage_hunk, "Stage git hunk")
				map("n", "<leader>gr", gitsigns.reset_hunk, "Reset git hunk")

				map("x", "<leader>gs", function()
					gitsigns.stage_hunk({
						vim.fn.line("."),
						vim.fn.line("v"),
					})
				end, "Stage selected git hunk")

				map("x", "<leader>gr", function()
					gitsigns.reset_hunk({
						vim.fn.line("."),
						vim.fn.line("v"),
					})
				end, "Reset selected git hunk")

				map("n", "<leader>gS", gitsigns.stage_buffer, "Stage git buffer")
				map("n", "<leader>gR", gitsigns.reset_buffer, "Reset git buffer")

				map("n", "<leader>gb", function()
					gitsigns.blame_line({
						full = true,
					})
				end, "Git blame line")

				map("n", "<leader>gq", gitsigns.setqflist, "Git hunks to quickfix")

				map({ "o", "x" }, "ih", gitsigns.select_hunk, "Git hunk text object")
			end,
		},
	},
}
