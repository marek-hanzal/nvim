local map = require("keymap.util").map

local M = {}

function M.attach(buffer)
	local gitsigns = require("gitsigns")
	local opts = {
		buffer = buffer,
	}

	map("n", "<leader>gn", function()
		gitsigns.nav_hunk("next")
	end, "Next git hunk", opts)

	map("n", "<leader>gN", function()
		gitsigns.nav_hunk("prev")
	end, "Previous git hunk", opts)
	map("n", "<leader>gp", gitsigns.preview_hunk, "Preview git hunk", opts)
	map("n", "<leader>gi", gitsigns.preview_hunk_inline, "Preview git hunk inline", opts)
	map("n", "<leader>gs", gitsigns.stage_hunk, "Stage git hunk", opts)
	map("n", "<leader>gr", gitsigns.reset_hunk, "Reset git hunk", opts)
	map("x", "<leader>gs", function()
		gitsigns.stage_hunk({
			vim.fn.line("."),
			vim.fn.line("v"),
		})
	end, "Stage selected git hunk", opts)
	map("x", "<leader>gr", function()
		gitsigns.reset_hunk({
			vim.fn.line("."),
			vim.fn.line("v"),
		})
	end, "Reset selected git hunk", opts)
	map("n", "<leader>gS", gitsigns.stage_buffer, "Stage git buffer", opts)
	map("n", "<leader>gR", gitsigns.reset_buffer, "Reset git buffer", opts)
	map("n", "<leader>gb", function()
		gitsigns.blame_line({
			full = true,
		})
	end, "Git blame line", opts)
	map("n", "<leader>gq", gitsigns.setqflist, "Git hunks to quickfix", opts)
	map({ "o", "x" }, "ih", gitsigns.select_hunk, "Git hunk text object", opts)
end

function M.setup()
	map("n", "<leader>gg", function()
		Snacks.lazygit()
	end, "LazyGit")

	map("n", "<leader>gB", function()
		require("fzf-lua").git_branches({
			previewer = false,
		})
	end, "Git branches")

	map("n", "<leader>gc", function()
		require("fzf-lua").git_commits({
			previewer = false,
		})
	end, "Git commits")

	map("n", "<leader>gC", function()
		require("fzf-lua").git_bcommits({
			previewer = false,
		})
	end, "Git buffer commits")

	map("n", "<leader>gl", function()
		Snacks.lazygit.log()
	end, "Git log")

	map("n", "<leader>gL", function()
		Snacks.lazygit.log_file()
	end, "Git file log")

	map("n", "<leader>gz", function()
		require("fzf-lua").git_stash({
			previewer = false,
		})
	end, "Git stash")
end

return M
