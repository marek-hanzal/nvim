local map = require("keymap.util").map

local M = {}

function M.setup()
	map("n", "<esc>", "<cmd>nohlsearch<cr>", "Clear search highlight")

	map({ "n", "x", "o" }, "<M-Left>", "b", "Move word left")
	map({ "n", "x", "o" }, "<M-Right>", "w", "Move word right")
	map({ "n", "x", "o" }, "<M-b>", "b", "Move word left")
	map({ "n", "x", "o" }, "<M-f>", "w", "Move word right")

	map("i", "<M-Left>", "<C-o>b", "Move word left")
	map("i", "<M-Right>", "<C-o>w", "Move word right")
	map("i", "<M-b>", "<C-o>b", "Move word left")
	map("i", "<M-f>", "<C-o>w", "Move word right")

	map("t", "<Esc><Esc>", [[<C-\><C-n>]], "Exit terminal mode")
	map("n", "<leader>e", "<cmd>Neotree toggle filesystem reveal left<cr>", "Toggle file explorer")
	map("n", "<leader>E", "<cmd>Neotree focus filesystem reveal left<cr>", "Focus file explorer")
	map("n", "<leader>eb", "<cmd>Neotree buffers left<cr>", "Buffer tree")

	map("n", "<M-Up>", function()
		require("mini.move").move_line("up")
	end, "Move line up")

	map("n", "<M-Down>", function()
		require("mini.move").move_line("down")
	end, "Move line down")

	map("x", "<M-Up>", function()
		require("mini.move").move_selection("up")
	end, "Move selection up")

	map("x", "<M-Down>", function()
		require("mini.move").move_selection("down")
	end, "Move selection down")

	map({ "i", "s" }, "<Tab>", function()
		local luasnip = require("luasnip")

		if luasnip.expand_or_locally_jumpable() then
			luasnip.expand_or_jump()
			return ""
		end

		return "<Tab>"
	end, "Expand or jump snippet", {
		expr = true,
		silent = true,
	})

	map({ "i", "s" }, "<S-Tab>", function()
		local luasnip = require("luasnip")

		if luasnip.locally_jumpable(-1) then
			luasnip.jump(-1)
			return ""
		end

		return "<S-Tab>"
	end, "Jump snippet back", {
		expr = true,
		silent = true,
	})
end

return M
