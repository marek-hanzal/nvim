vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.have_nerd_font = true

vim.filetype.add({
	extension = {
		tf = "terraform",
		tfvars = "terraform-vars",
	},
})

local opt = vim.opt
local uv = vim.uv or vim.loop

local function is_wsl()
	if vim.fn.has("wsl") == 1 then
		return true
	end

	return uv.os_uname().release:lower():find("microsoft", 1, true) ~= nil
end

opt.number = true
opt.relativenumber = false
opt.cursorline = true

opt.cmdheight = 0
opt.showmode = false

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true

opt.smartindent = true
opt.wrap = false

opt.ignorecase = true
opt.smartcase = true
opt.iskeyword:append("-")
opt.selection = "inclusive"

opt.termguicolors = true
opt.signcolumn = "yes"

-- Keep implicit register writes out of the system clipboard; yanks/deletes are
-- copied explicitly from TextYankPost in autocmds.lua.
opt.clipboard = ""

if is_wsl() and vim.fn.executable("clip.exe") == 1 and vim.fn.executable("powershell.exe") == 1 then
	local paste =
		[[powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))]]

	vim.g.clipboard = {
		name = "WslClipboard",
		copy = {
			["+"] = "clip.exe",
			["*"] = "clip.exe",
		},
		paste = {
			["+"] = paste,
			["*"] = paste,
		},
		cache_enabled = 0,
	}
end

opt.splitright = true
opt.splitbelow = true

opt.autowrite = false

opt.backspace = "indent,eol,start"
opt.errorbells = false
opt.autochdir = false

opt.undofile = true
opt.shada = "'100,<50,s10,h"
opt.sessionoptions = {
	"buffers",
	"curdir",
	"tabpages",
	"winsize",
	"help",
	"globals",
	"skiprtp",
	"folds",
}
opt.encoding = "UTF-8"

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

-- Let gf/gF treat path segments like "@migrations" as part of the filename.
opt.isfname:append("@-@")
