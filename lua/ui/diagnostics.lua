local M = {}

local severity_highlights = {
	[vim.diagnostic.severity.ERROR] = "DiagnosticError",
	[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
	[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
	[vim.diagnostic.severity.HINT] = "DiagnosticHint",
}

local findings_namespace = vim.api.nvim_create_namespace("diagnostics-findings")

local severity_line_highlights = {
	[vim.diagnostic.severity.ERROR] = "DiagnosticsFindingError",
	[vim.diagnostic.severity.WARN] = "DiagnosticsFindingWarn",
	[vim.diagnostic.severity.INFO] = "DiagnosticsFindingInfo",
	[vim.diagnostic.severity.HINT] = "DiagnosticsFindingHint",
}

local function blend_channel(foreground, background, alpha)
	return math.floor((alpha * foreground) + ((1 - alpha) * background) + 0.5)
end

local function blend_colors(foreground, background, alpha)
	if not foreground or not background then
		return foreground or background
	end

	local red = blend_channel(bit.rshift(foreground, 16), bit.rshift(background, 16), alpha)
	local green = blend_channel(bit.band(bit.rshift(foreground, 8), 0xFF), bit.band(bit.rshift(background, 8), 0xFF), alpha)
	local blue = blend_channel(bit.band(foreground, 0xFF), bit.band(background, 0xFF), alpha)

	return bit.lshift(red, 16) + bit.lshift(green, 8) + blue
end

local function get_highlight(name)
	local ok, highlight = pcall(vim.api.nvim_get_hl, 0, {
		name = name,
		link = false,
	})

	if not ok then
		return {}
	end

	return highlight
end

local function define_severity_highlights()
	local base = get_highlight("NormalFloat")

	if not base.bg then
		base = get_highlight("Normal")
	end

	local base_bg = base.bg or 0

	for severity, diagnostic_group in pairs(severity_highlights) do
		local line_group = severity_line_highlights[severity]
		local diagnostic_highlight = get_highlight(diagnostic_group)
		local foreground = diagnostic_highlight.fg or base.fg
		local background = blend_colors(foreground, base_bg, 0.12)

		vim.api.nvim_set_hl(0, line_group, {
			fg = foreground,
			bg = background,
		})
	end
end

local function truncate_text(text, max_width)
	if max_width <= 3 then
		return text:sub(1, max_width)
	end

	if vim.fn.strdisplaywidth(text) <= max_width then
		return text
	end

	return vim.fn.strcharpart(text, 0, max_width - 3) .. "..."
end

local function normalize_message(message)
	return (message or ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
end

local function make_scratch_buffer()
	local bufnr = vim.api.nvim_create_buf(false, true)

	vim.bo[bufnr].buftype = "nofile"
	vim.bo[bufnr].bufhidden = "wipe"
	vim.bo[bufnr].swapfile = false
	vim.bo[bufnr].modifiable = false
	vim.bo[bufnr].undofile = false

	return bufnr
end

local function apply_buffer_options(bufnr, options)
	for name, value in pairs(options) do
		vim.bo[bufnr][name] = value
	end
end

local function set_buffer_lines(bufnr, lines)
	vim.bo[bufnr].modifiable = true
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.bo[bufnr].modifiable = false
end

local function sort_diagnostics(diagnostics)
	table.sort(diagnostics, function(a, b)
		if a.severity ~= b.severity then
			return a.severity < b.severity
		end

		if a.bufnr ~= b.bufnr then
			local a_name = vim.api.nvim_buf_get_name(a.bufnr)
			local b_name = vim.api.nvim_buf_get_name(b.bufnr)

			return a_name < b_name
		end

		if a.lnum ~= b.lnum then
			return a.lnum < b.lnum
		end

		return a.col < b.col
	end)
end

local function format_list_entry(diagnostic, max_width)
	local source = normalize_message(diagnostic.source)
	local summary = normalize_message(diagnostic.message)
	local code = diagnostic.code and string.format(" [%s]", diagnostic.code) or ""
	local source_label = source ~= "" and source or "diagnostic"
	local line = string.format("[%s]: %s%s", source_label, summary, code)

	return truncate_text(line, max_width)
end

local function build_text_lines(diagnostic)
	local lines = vim.split(diagnostic.message or "", "\n", { plain = true })

	if vim.tbl_isempty(lines) then
		return { "(empty diagnostic message)" }
	end

	return lines
end

local top_border = {
	"╭",
	"─",
	"╮",
	"│",
	"┤",
	"─",
	"├",
	"│",
}

local middle_border = {
	"├",
	"─",
	"┤",
	"│",
	"┤",
	"─",
	"├",
	"│",
}

local bottom_border = {
	"├",
	"─",
	"┤",
	"│",
	"╯",
	"─",
	"╰",
	"│",
}

local function set_window_options(winid, opts)
	for name, value in pairs(opts) do
		vim.wo[winid][name] = value
	end
end

local function open_window(bufnr, config)
	return vim.api.nvim_open_win(bufnr, false, vim.tbl_extend("force", {
		relative = "editor",
		style = "minimal",
		zindex = 60,
	}, config))
end

local function shift_window_horizontally(winid, delta)
	if not vim.api.nvim_win_is_valid(winid) then
		return
	end

	vim.api.nvim_win_call(winid, function()
		local view = vim.fn.winsaveview()
		view.leftcol = math.max((view.leftcol or 0) + delta, 0)
		vim.fn.winrestview(view)
	end)
end

local function close_state(state)
	if state.closed then
		return
	end

	state.closed = true

	if state.augroup then
		pcall(vim.api.nvim_del_augroup_by_id, state.augroup)
	end

	for _, winid in ipairs({
		state.list_win,
		state.text_win,
		state.preview_win,
	}) do
		if winid and vim.api.nvim_win_is_valid(winid) then
			pcall(vim.api.nvim_win_close, winid, true)
		end
	end
end

local function current_diagnostic(state)
	return state.diagnostics[vim.api.nvim_win_get_cursor(state.list_win)[1]]
end

local function render(state)
	local diagnostic = current_diagnostic(state)

	if not diagnostic then
		return
	end

	local text_lines = build_text_lines(diagnostic)
	set_buffer_lines(state.text_buf, text_lines)

	local preview_buf = vim.fn.bufadd(vim.api.nvim_buf_get_name(diagnostic.bufnr))
	vim.fn.bufload(preview_buf)
	vim.api.nvim_win_set_buf(state.preview_win, preview_buf)
	vim.api.nvim_win_set_cursor(state.preview_win, {
		math.min(diagnostic.lnum + 1, vim.api.nvim_buf_line_count(preview_buf)),
		diagnostic.col,
	})
	vim.api.nvim_win_call(state.preview_win, function()
		vim.cmd("normal! zz")
	end)

	set_window_options(state.preview_win, {
		number = true,
		relativenumber = false,
		cursorline = true,
		wrap = false,
		scrolloff = 3,
		sidescrolloff = 4,
		signcolumn = "yes",
	})

	vim.api.nvim_win_call(state.text_win, function()
		vim.fn.winrestview({
			lnum = 1,
			col = 0,
			leftcol = state.detail_leftcol,
			topline = 1,
		})
	end)
end

local function build_list_lines(diagnostics, width)
	local lines = {}

	for _, diagnostic in ipairs(diagnostics) do
		lines[#lines + 1] = format_list_entry(diagnostic, width)
	end

	return lines
end

local function highlight_list(bufnr, diagnostics)
	for index, diagnostic in ipairs(diagnostics) do
		vim.api.nvim_buf_set_extmark(bufnr, findings_namespace, index - 1, 0, {
			line_hl_group = severity_line_highlights[diagnostic.severity] or "Normal",
		})
	end
end

local function setup_close_keymaps(state, bufnrs)
	for _, bufnr in ipairs(bufnrs) do
		vim.keymap.set("n", "q", function()
			close_state(state)
		end, {
			buffer = bufnr,
			nowait = true,
			silent = true,
		})
		vim.keymap.set("n", "<Esc>", function()
			close_state(state)
		end, {
			buffer = bufnr,
			nowait = true,
			silent = true,
		})
	end
end

local function setup_list_keymaps(state)
	local opts = {
		buffer = state.list_buf,
		nowait = true,
		silent = true,
	}

	local function move_selection(delta)
		local line_count = #state.diagnostics
		local current = vim.api.nvim_win_get_cursor(state.list_win)[1]
		local target = math.min(math.max(current + delta, 1), line_count)
		vim.api.nvim_win_set_cursor(state.list_win, { target, 0 })
	end

	local function open_selected()
		local diagnostic = current_diagnostic(state)

		if not diagnostic then
			return
		end

		close_state(state)
		vim.api.nvim_set_current_buf(diagnostic.bufnr)
		vim.api.nvim_win_set_cursor(0, { diagnostic.lnum + 1, diagnostic.col })
		vim.cmd("normal! zz")
	end

	local function scroll_message(delta)
		state.detail_leftcol = math.max(state.detail_leftcol + delta, 0)
		shift_window_horizontally(state.text_win, delta)
	end

	vim.keymap.set("n", "<Up>", function()
		move_selection(-1)
	end, opts)
	vim.keymap.set("n", "<Down>", function()
		move_selection(1)
	end, opts)
	vim.keymap.set("n", "<Left>", function()
		scroll_message(-8)
	end, opts)
	vim.keymap.set("n", "<Right>", function()
		scroll_message(8)
	end, opts)
	vim.keymap.set("n", "k", function()
		move_selection(-1)
	end, opts)
	vim.keymap.set("n", "j", function()
		move_selection(1)
	end, opts)
	vim.keymap.set("n", "<CR>", open_selected, opts)
end

local function open_picker(diagnostics)
	if vim.tbl_isempty(diagnostics) then
		vim.notify("No diagnostics found", vim.log.levels.INFO)
		return
	end

	define_severity_highlights()
	sort_diagnostics(diagnostics)

	local ui = vim.api.nvim_list_uis()[1]
	local width = math.max(ui.width, 80)
	local height = math.max(ui.height - vim.o.cmdheight, 24)

	local findings_height = math.max(math.floor(height * 0.25), 6)
	local message_height = math.max(math.floor(height * 0.50), 8)
	local preview_height = height - findings_height - message_height

	if preview_height < 6 then
		preview_height = 6
		message_height = math.max(height - findings_height - preview_height, 8)
	end

	local list_buf = make_scratch_buffer()
	local text_buf = make_scratch_buffer()

	apply_buffer_options(list_buf, {
		filetype = "diaglist",
	})
	apply_buffer_options(text_buf, {
		filetype = "text",
	})

	local list_win = vim.api.nvim_open_win(list_buf, true, {
		relative = "editor",
		row = 0,
		col = 0,
		width = width,
		height = findings_height,
		border = top_border,
		title = " Findings ",
		title_pos = "center",
		style = "minimal",
		zindex = 60,
	})

	local text_win = open_window(text_buf, {
		row = findings_height,
		col = 0,
		width = width,
		height = message_height,
		border = middle_border,
	})

	local preview_win = open_window(0, {
		row = findings_height + message_height,
		col = 0,
		width = width,
		height = preview_height,
		border = bottom_border,
	})

	local state = {
		closed = false,
		diagnostics = diagnostics,
		detail_leftcol = 0,
		list_buf = list_buf,
		text_buf = text_buf,
		list_win = list_win,
		text_win = text_win,
		preview_win = preview_win,
	}

	set_buffer_lines(list_buf, build_list_lines(diagnostics, vim.api.nvim_win_get_width(list_win) - 2))
	highlight_list(list_buf, diagnostics)

	set_window_options(list_win, {
		number = false,
		relativenumber = false,
		cursorline = true,
		wrap = false,
		scrolloff = 3,
		sidescrolloff = 2,
		signcolumn = "no",
	})

	set_window_options(text_win, {
		number = false,
		relativenumber = false,
		cursorline = false,
		wrap = false,
		scrolloff = 0,
		sidescrolloff = 4,
		signcolumn = "no",
	})

	setup_close_keymaps(state, {
		list_buf,
		text_buf,
	})
	setup_list_keymaps(state)

	state.augroup = vim.api.nvim_create_augroup("custom-diagnostics-" .. list_buf, { clear = true })

	vim.api.nvim_create_autocmd("CursorMoved", {
		buffer = list_buf,
		group = state.augroup,
		callback = function()
			if state.closed then
				return
			end

			render(state)
		end,
	})

	vim.api.nvim_create_autocmd("WinClosed", {
		group = state.augroup,
		pattern = {
			tostring(list_win),
			tostring(text_win),
			tostring(preview_win),
		},
		callback = function()
			close_state(state)
		end,
	})

	render(state)
end

function M.open_document()
	open_picker(vim.diagnostic.get(0))
end

function M.open_workspace()
	open_picker(vim.diagnostic.get(nil))
end

return M
