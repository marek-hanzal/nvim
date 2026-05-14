local keymap = vim.keymap.set

keymap("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
keymap("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit window" })

keymap("n", "<c-h>", "<c-w>h", { desc = "Move to left window" })
keymap("n", "<c-l>", "<c-w>l", { desc = "Move to right window" })

keymap("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

keymap("n", "<leader>h", "<cmd>split<cr>", { desc = "Horizontal split" })
keymap("n", "<leader>v", "<cmd>vsplit<cr>", { desc = "Vertical split" })

-- Word movement with Alt/Meta arrows.
-- Covers both real <M-Left>/<M-Right> and terminals that send Esc-b / Esc-f.
keymap({ "n", "x", "o" }, "<M-Left>", "b", { desc = "Move word left" })
keymap({ "n", "x", "o" }, "<M-Right>", "w", { desc = "Move word right" })
keymap({ "n", "x", "o" }, "<M-b>", "b", { desc = "Move word left" })
keymap({ "n", "x", "o" }, "<M-f>", "w", { desc = "Move word right" })

keymap("i", "<M-Left>", "<C-o>b", { desc = "Move word left" })
keymap("i", "<M-Right>", "<C-o>w", { desc = "Move word right" })
keymap("i", "<M-b>", "<C-o>b", { desc = "Move word left" })
keymap("i", "<M-f>", "<C-o>w", { desc = "Move word right" })
