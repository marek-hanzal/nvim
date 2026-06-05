local map = require("keymap.util").map

local M = {}

local function blackhole_if_unnamed(lhs)
	return function()
		if vim.v.register == '"' then
			return '"_' .. lhs
		end

		return lhs
	end
end

local function visual_paste_preserving_register()
	local register = vim.v.register

	if register == '"' then
		return '"_dP'
	end

	return '"_d"' .. register .. "P"
end

function M.setup()
	map("n", "<esc>", "<cmd>nohlsearch<cr>", "Clear search highlight")

	map({ "n", "x" }, "c", blackhole_if_unnamed("c"), "Change without yanking", { expr = true })
	map({ "n", "x" }, "C", blackhole_if_unnamed("C"), "Change line without yanking", { expr = true })
	map({ "n", "x" }, "s", blackhole_if_unnamed("s"), "Substitute without yanking", { expr = true })
	map({ "n", "x" }, "S", blackhole_if_unnamed("S"), "Substitute line without yanking", { expr = true })
	map({ "n", "x" }, "x", blackhole_if_unnamed("x"), "Delete character without yanking", { expr = true })
	map({ "n", "x" }, "X", blackhole_if_unnamed("X"), "Delete previous character without yanking", { expr = true })
	map("x", "p", visual_paste_preserving_register, "Paste without yanking replaced text", { expr = true })

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
	map("n", "<leader>tt", function()
		vim.cmd("botright split")
		vim.cmd("terminal")
		vim.cmd("startinsert")
	end, "Open terminal bottom")

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

	map(
		{ "i", "s" },
		"<Tab>",
		function()
			local luasnip = require("luasnip")

			if luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
				return ""
			end

			return "<Tab>"
		end,
		"Expand or jump snippet",
		{
			expr = true,
			silent = true,
		}
	)

	map(
		{ "i", "s" },
		"<S-Tab>",
		function()
			local luasnip = require("luasnip")

			if luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
				return ""
			end

			return "<S-Tab>"
		end,
		"Jump snippet back",
		{
			expr = true,
			silent = true,
		}
	)

	map("n", "<PageDown>", "<C-d>zz", "Half page down and center")

	map("n", "<PageUp>", "<C-u>zz", "Half page up and center")
end

return M
