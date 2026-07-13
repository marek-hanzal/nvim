local map = require("keymap.util").map

local M = {}

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

function M.setup()
	map("n", "<leader>tt", function()
		vim.cmd("botright split")
		vim.cmd("terminal")
		vim.cmd("startinsert")
	end, "Open terminal bottom")

	map("n", "<leader>tn", function()
		require("todo-comments").jump_next()
	end, "Next todo comment")

	map("n", "<leader>tp", function()
		require("todo-comments").jump_prev()
	end, "Previous todo comment")

	vim.api.nvim_create_autocmd("TermOpen", {
		group = vim.api.nvim_create_augroup("terminal_file_nav", { clear = true }),
		callback = function(event)
			local opts = {
				buf = event.buf,
				silent = true,
			}

			map({ "n", "t" }, "gf", function()
				open_terminal_file()
			end, "Open file under cursor in previous window", opts)

			map({ "n", "t" }, "gF", function()
				open_terminal_file({ line = true })
			end, "Open file under cursor and jump to line in previous window", opts)
		end,
	})
end

return M
