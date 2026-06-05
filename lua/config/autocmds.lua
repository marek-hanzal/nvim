-- Highlight yanks

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
require("util.buffer_prune").setup()

local function terminal_cfile()
	local token = vim.fn.expand("<cWORD>")

	if token == "" then
		return nil, nil
	end

	token = token:gsub("^['\"(<%[]+", ""):gsub("[>'\"%)%]},;]+$", "")

	local path, line = token:match("^(.-):(%d+):%d+$")

	if path then
		return path, tonumber(line)
	end

	path, line = token:match("^(.-):(%d+)$")

	if path then
		return path, tonumber(line)
	end

	return vim.fn.expand("<cfile>"), nil
end

local function open_terminal_file(opts)
	opts = opts or {}

	local file, line = terminal_cfile()

	if not file or file == "" then
		vim.notify("No file under cursor", vim.log.levels.WARN)
		return
	end

	vim.cmd("stopinsert")

	if vim.fn.winnr("#") > 0 then
		vim.cmd("wincmd p")
	end

	vim.cmd("edit " .. vim.fn.fnameescape(file))

	if opts.line and line then
		vim.api.nvim_win_set_cursor(0, { line, 0 })
	end
end

autocmd("TextYankPost", {
	group = augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

autocmd("TextYankPost", {
	group = augroup("copy_yank_delete_to_clipboard", { clear = true }),
	callback = function()
		local event = vim.v.event

		if (event.operator ~= "y" and event.operator ~= "d") or event.regname ~= "" then
			return
		end

		vim.fn.setreg("+", event.regcontents, event.regtype)
	end,
})

-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	callback = function()
-- 		if vim.fn.argc() > 0 then
-- 			return
-- 		end
--
-- 		vim.cmd("Neotree toggle filesystem reveal left")
-- 		vim.cmd("wincmd p")
-- 	end,
-- })

autocmd("TermOpen", {
	group = augroup("terminal_file_nav", { clear = true }),
	callback = function(args)
		local map_opts = {
			buffer = args.buf,
			silent = true,
		}

		vim.keymap.set({ "n", "t" }, "gf", function()
			open_terminal_file()
		end, vim.tbl_extend("force", map_opts, {
			desc = "Open file under cursor in previous window",
		}))

		vim.keymap.set({ "n", "t" }, "gF", function()
			open_terminal_file({ line = true })
		end, vim.tbl_extend("force", map_opts, {
			desc = "Open file under cursor and jump to line in previous window",
		}))
	end,
})
