vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.have_nerd_font = true

local opt = vim.opt

opt.number = true
opt.relativenumber = false
opt.cursorline = true

opt.cmdheight = 0

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true

opt.smartindent = true
opt.wrap = false

opt.ignorecase = true
opt.smartcase = true

opt.termguicolors = true
opt.signcolumn = "yes"

opt.clipboard = "unnamedplus"

opt.splitright = true
opt.splitbelow = true

opt.undofile = true

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.updatetime = 250
opt.timeoutlen = 400

opt.wildmode = {
	"longest:full",
	"full",
}

opt.wildmenu = true
opt.wildignorecase = true
