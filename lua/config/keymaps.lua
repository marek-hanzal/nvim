local keymap = vim.keymap.set

keymap("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

keymap({ "n", "x", "o" }, "<M-Left>", "b", { desc = "Move word left" })
keymap({ "n", "x", "o" }, "<M-Right>", "w", { desc = "Move word right" })
keymap({ "n", "x", "o" }, "<M-b>", "b", { desc = "Move word left" })
keymap({ "n", "x", "o" }, "<M-f>", "w", { desc = "Move word right" })

keymap("i", "<M-Left>", "<C-o>b", { desc = "Move word left" })
keymap("i", "<M-Right>", "<C-o>w", { desc = "Move word right" })
keymap("i", "<M-b>", "<C-o>b", { desc = "Move word left" })
keymap("i", "<M-f>", "<C-o>w", { desc = "Move word right" })

keymap("n", "<leader>cd", vim.diagnostic.open_float, {
  desc = "Line diagnostic",
})

keymap("n", "<leader>cq", vim.diagnostic.setloclist, {
  desc = "Diagnostics to location list",
})

keymap("t", "<Esc><Esc>", [[<C-\><C-n>]], {
	desc = "Exit terminal mode",
})
