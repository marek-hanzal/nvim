local M = {}

local findings_namespace = vim.api.nvim_create_namespace("diagnostics-findings")
local preview_namespace = vim.api.nvim_create_namespace("diagnostics-preview")
local message_scroll_step = 16

local severity_highlights = {
	[vim.diagnostic.severity.ERROR] = "DiagnosticError",
	[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
	[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
	[vim.diagnostic.severity.HINT] = "DiagnosticHint",
}

local severity_line_highlights = {
	[vim.diagnostic.severity.ERROR] = "DiagnosticsFindingError",
	[vim.diagnostic.severity.WARN] = "DiagnosticsFindingWarn",
	[vim.diagnostic.severity.INFO] = "DiagnosticsFindingInfo",
	[vim.diagnostic.severity.HINT] = "DiagnosticsFindingHint",
}

local severity_current_highlights = {
	[vim.diagnostic.severity.ERROR] = "DiagnosticsFindingCurrentError",
	[vim.diagnostic.severity.WARN] = "DiagnosticsFindingCurrentWarn",
	[vim.diagnostic.severity.INFO] = "DiagnosticsFindingCurrentInfo",
	[vim.diagnostic.severity.HINT] = "DiagnosticsFindingCurrentHint",
}

local severity_preview_range_highlights = {
	[vim.diagnostic.severity.ERROR] = "DiagnosticUnderlineError",
	[vim.diagnostic.severity.WARN] = "DiagnosticUnderlineWarn",
	[vim.diagnostic.severity.INFO] = "DiagnosticUnderlineInfo",
	[vim.diagnostic.severity.HINT] = "DiagnosticUnderlineHint",
}

local function blend_channel(foreground, background, alpha)
	return math.floor((alpha * foreground) + ((1 - alpha) * background) + 0.5)
end

local function blend_colors(foreground, background, alpha)
	if not foreground or not background then
		return foreground or background
	end

	local red = blend_channel(bit.rshift(foreground, 16), bit.rshift(background, 16), alpha)
	local green =
		blend_channel(bit.band(bit.rshift(foreground, 8), 0xFF), bit.band(bit.rshift(background, 8), 0xFF), alpha)
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
		local diagnostic_highlight = get_highlight(diagnostic_group)
		local foreground = diagnostic_highlight.fg or base.fg

		vim.api.nvim_set_hl(0, severity_line_highlights[severity], {
			fg = foreground,
			bg = blend_colors(foreground, base_bg, 0.12),
		})

		vim.api.nvim_set_hl(0, severity_current_highlights[severity], {
			fg = foreground,
			bg = blend_colors(foreground, base_bg, 0.22),
			bold = true,
		})
	end
end

local function normalize_message(message)
	return (message or ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
end

local function truncate_text(text, max_width)
	if max_width <= 3 then
		return text:sub(1, max_width), true
	end

	if vim.fn.strdisplaywidth(text) <= max_width then
		return text, false
	end

	return vim.fn.strcharpart(text, 0, max_width - 3) .. "...", true
end

local function make_scratch_buffer()
	local bufnr = vim.api.nvim_create_buf(false, true)

	vim.bo[bufnr].buftype = "nofile"
	vim.bo[bufnr].bufhidden = "hide"
	vim.bo[bufnr].swapfile = false
	vim.bo[bufnr].modifiable = false
	vim.bo[bufnr].undofile = false

	return bufnr
end

local function set_buffer_lines(bufnr, lines)
	vim.bo[bufnr].modifiable = true
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.bo[bufnr].modifiable = false
end

local function set_window_options(winid, options)
	for name, value in pairs(options) do
		vim.wo[winid][name] = value
	end
end

local function open_window(bufnr, enter, config)
	return vim.api.nvim_open_win(
		bufnr,
		enter,
		vim.tbl_extend("force", {
			relative = "editor",
			style = "minimal",
			zindex = 60,
			border = "single",
		}, config)
	)
end

local function clamp(value, min_value, max_value)
	return math.min(math.max(value, min_value), max_value)
end

local function get_text_width(winid)
	return vim.api.nvim_win_call(winid, function()
		local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1] or {}
		local textoff = wininfo.textoff or 0

		return math.max(vim.fn.winwidth(0) - textoff, 1)
	end)
end

local function sort_diagnostics(diagnostics)
	table.sort(diagnostics, function(a, b)
		if a.severity ~= b.severity then
			return a.severity < b.severity
		end

		if a.bufnr ~= b.bufnr then
			return vim.api.nvim_buf_get_name(a.bufnr) < vim.api.nvim_buf_get_name(b.bufnr)
		end

		if a.lnum ~= b.lnum then
			return a.lnum < b.lnum
		end

		return a.col < b.col
	end)
end

local function find_nearest_diagnostic_index(diagnostics, bufnr, cursor_line, cursor_col)
	local exact_line_index
	local exact_line_col_delta = math.huge
	local nearest_index = 1
	local nearest_line_delta = math.huge
	local nearest_col_delta = math.huge

	for index, diagnostic in ipairs(diagnostics) do
		if diagnostic.bufnr == bufnr then
			local line_delta = math.abs((diagnostic.lnum or 0) - cursor_line)
			local col_delta = math.abs((diagnostic.col or 0) - cursor_col)

			if line_delta == 0 and col_delta < exact_line_col_delta then
				exact_line_index = index
				exact_line_col_delta = col_delta
			end

			if
				line_delta < nearest_line_delta or (line_delta == nearest_line_delta and col_delta < nearest_col_delta)
			then
				nearest_index = index
				nearest_line_delta = line_delta
				nearest_col_delta = col_delta
			end
		end
	end

	return exact_line_index or nearest_index
end

local function build_entries(diagnostics, width)
	local entries = {}

	for _, diagnostic in ipairs(diagnostics) do
		local source = normalize_message(diagnostic.source)
		local summary = normalize_message(diagnostic.message)
		local code = diagnostic.code and string.format(" [%s]", diagnostic.code) or ""
		local source_label = source ~= "" and source or "diagnostic"
		local detail = "[" .. source_label .. "]: " .. summary .. code
		local display = truncate_text("  " .. detail, width)

		entries[#entries + 1] = {
			diagnostic = diagnostic,
			detail = detail,
			display = display,
		}
	end

	return entries
end

local function build_list_lines(entries)
	local lines = {}

	for _, entry in ipairs(entries) do
		lines[#lines + 1] = entry.display
	end

	return lines
end

local function entry_line(index)
	return (index - 1)
end

local function current_entry(state)
	return state.entries[state.current_index]
end

local function current_diagnostic(state)
	local entry = current_entry(state)
	return entry and entry.diagnostic or nil
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

	if state.preview_buf and vim.api.nvim_buf_is_valid(state.preview_buf) then
		vim.api.nvim_buf_clear_namespace(state.preview_buf, preview_namespace, 0, -1)
	end

	if state.augroup then
		pcall(vim.api.nvim_del_augroup_by_id, state.augroup)
	end

	for _, winid in ipairs({ state.list_win, state.text_win, state.preview_win }) do
		if winid and vim.api.nvim_win_is_valid(winid) then
			pcall(vim.api.nvim_win_close, winid, true)
		end
	end

	if state.return_win and vim.api.nvim_win_is_valid(state.return_win) then
		pcall(vim.api.nvim_set_current_win, state.return_win)
	end
end

local function set_preview_buffer(state, bufnr)
	if not (bufnr and vim.api.nvim_buf_is_valid(bufnr)) then
		return
	end

	if not vim.api.nvim_buf_is_loaded(bufnr) then
		vim.fn.bufload(bufnr)
	end

	if state.preview_buf and state.preview_buf ~= bufnr and vim.api.nvim_buf_is_valid(state.preview_buf) then
		vim.api.nvim_buf_clear_namespace(state.preview_buf, preview_namespace, 0, -1)
	end

	state.preview_buf = bufnr
	vim.api.nvim_win_set_buf(state.preview_win, bufnr)
end

local function apply_list_highlights(state)
	vim.api.nvim_buf_clear_namespace(state.list_buf, findings_namespace, 0, -1)

	for index, entry in ipairs(state.entries) do
		local highlight = severity_line_highlights[entry.diagnostic.severity] or "Normal"

		if index == state.current_index then
			highlight = severity_current_highlights[entry.diagnostic.severity] or highlight
		end

		vim.api.nvim_buf_set_extmark(state.list_buf, findings_namespace, entry_line(index), 0, {
			line_hl_group = highlight,
		})
	end
end

local function normalize_cursor(state)
	local cursor = vim.api.nvim_win_get_cursor(state.list_win)
	local next_index = cursor[1]
	local target_index = math.min(math.max(next_index, 1), #state.entries)
	local target_line = entry_line(target_index) + 1
	local index_changed = state.current_index ~= target_index

	state.current_index = target_index

	if index_changed then
		state.detail_leftcol = 0
	end

	if cursor[1] ~= target_line then
		state.normalizing = true
		vim.api.nvim_win_set_cursor(state.list_win, { target_line, 0 })
		state.normalizing = false
	end
end

local function highlight_preview_location(bufnr, diagnostic)
	vim.api.nvim_buf_clear_namespace(bufnr, preview_namespace, 0, -1)

	local line = math.min(diagnostic.lnum, math.max(vim.api.nvim_buf_line_count(bufnr) - 1, 0))
	local line_text = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1] or ""
	local start_col = math.min(diagnostic.col or 0, #line_text)
	local end_col = diagnostic.end_col

	if diagnostic.end_lnum and diagnostic.end_lnum == diagnostic.lnum and end_col then
		end_col = math.min(math.max(end_col, start_col + 1), #line_text)
	else
		end_col = math.min(start_col + 1, #line_text)
	end

	if end_col <= start_col then
		end_col = math.min(start_col + 1, #line_text + 1)
	end

	vim.api.nvim_buf_set_extmark(bufnr, preview_namespace, line, 0, {
		line_hl_group = "CursorLine",
	})

	vim.api.nvim_buf_set_extmark(bufnr, preview_namespace, line, start_col, {
		end_row = line,
		end_col = end_col,
		hl_group = severity_preview_range_highlights[diagnostic.severity] or "Visual",
	})
end

local function render(state)
	local entry = current_entry(state)
	local diagnostic = current_diagnostic(state)

	if not entry or not diagnostic then
		return
	end

	set_buffer_lines(state.text_buf, { entry.detail })
	set_preview_buffer(state, diagnostic.bufnr)
	highlight_preview_location(state.preview_buf, diagnostic)
	vim.api.nvim_win_set_cursor(state.preview_win, {
		math.min(diagnostic.lnum + 1, vim.api.nvim_buf_line_count(state.preview_buf)),
		diagnostic.col or 0,
	})

	vim.api.nvim_win_call(state.preview_win, function()
		vim.cmd("normal! zz")
	end)

	vim.api.nvim_win_call(state.text_win, function()
		vim.fn.winrestview({
			lnum = 1,
			col = 0,
			leftcol = state.detail_leftcol,
			topline = 1,
		})
	end)
end

local function setup_keymaps(state, bufnrs)
	local function move_selection(delta)
		local target = math.min(math.max(state.current_index + delta, 1), #state.entries)

		if target ~= state.current_index then
			state.detail_leftcol = 0
		end

		state.current_index = target
		vim.api.nvim_win_set_cursor(state.list_win, { entry_line(target) + 1, 0 })
		apply_list_highlights(state)
		render(state)
	end

	local function open_selected()
		local diagnostic = current_diagnostic(state)

		if not diagnostic then
			return
		end

		close_state(state)
		vim.api.nvim_set_current_buf(diagnostic.bufnr)
		vim.api.nvim_win_set_cursor(0, { diagnostic.lnum + 1, diagnostic.col or 0 })
		vim.cmd("normal! zz")
	end

	local function scroll_message(delta)
		state.detail_leftcol = math.max(state.detail_leftcol + delta, 0)
		shift_window_horizontally(state.text_win, delta)
	end

	for _, bufnr in ipairs(bufnrs) do
		local opts = {
			buffer = bufnr,
			nowait = true,
			silent = true,
		}

		vim.keymap.set("n", "q", function()
			close_state(state)
		end, opts)
		vim.keymap.set("n", "<Esc>", function()
			close_state(state)
		end, opts)
		vim.keymap.set("n", "<Up>", function()
			move_selection(-1)
		end, opts)
		vim.keymap.set("n", "<Down>", function()
			move_selection(1)
		end, opts)
		vim.keymap.set("n", "k", function()
			move_selection(-1)
		end, opts)
		vim.keymap.set("n", "j", function()
			move_selection(1)
		end, opts)
		vim.keymap.set("n", "<Left>", function()
			scroll_message(-message_scroll_step)
		end, opts)
		vim.keymap.set("n", "<Right>", function()
			scroll_message(message_scroll_step)
		end, opts)
		vim.keymap.set("n", "<CR>", open_selected, opts)
	end
end

local function open_picker(diagnostics, opts)
	if vim.tbl_isempty(diagnostics) then
		vim.notify("No diagnostics found", vim.log.levels.INFO)
		return
	end

	opts = opts or {}

	if not opts.sorted then
		sort_diagnostics(diagnostics)
	end

	define_severity_highlights()

	local ui = vim.api.nvim_list_uis()[1]
	local return_win = vim.api.nvim_get_current_win()
	local width = math.max(ui.width - 2, 1)
	local total_height = math.max(ui.height - vim.o.cmdheight, 1)

	if width < 20 or total_height < 9 then
		vim.notify("Diagnostics UI needs a larger editor area", vim.log.levels.WARN)
		return
	end

	local inner_height = math.max(total_height - 6, 1)
	local findings_height = clamp(math.floor(inner_height * 0.25), 3, inner_height)
	local message_height = clamp(math.floor(inner_height * 0.50), 3, inner_height - findings_height)
	local preview_height = math.max(inner_height - findings_height - message_height, 1)

	local list_buf = make_scratch_buffer()
	local text_buf = make_scratch_buffer()
	local preview_buf = make_scratch_buffer()

	vim.bo[list_buf].filetype = "diaglist"
	vim.bo[text_buf].filetype = "text"

	local list_win = open_window(list_buf, true, {
		row = 0,
		col = 0,
		width = width,
		height = findings_height,
		title = " Findings ",
		title_pos = "center",
	})

	local text_win = open_window(text_buf, false, {
		row = findings_height + 2,
		col = 0,
		width = width,
		height = message_height,
	})

	local preview_win = open_window(preview_buf, false, {
		row = findings_height + message_height + 4,
		col = 0,
		width = width,
		height = preview_height,
	})

	local state = {
		augroup = nil,
		closed = false,
		current_index = math.min(math.max(opts.initial_index or 1, 1), #diagnostics),
		detail_leftcol = 0,
		entries = {},
		list_buf = list_buf,
		list_win = list_win,
		normalizing = false,
		preview_buf = preview_buf,
		preview_win = preview_win,
		return_win = return_win,
		text_buf = text_buf,
		text_win = text_win,
	}

	state.entries = build_entries(diagnostics, get_text_width(list_win))
	set_buffer_lines(list_buf, build_list_lines(state.entries))
	vim.api.nvim_win_set_cursor(list_win, { entry_line(state.current_index) + 1, 0 })

	set_window_options(list_win, {
		number = false,
		relativenumber = false,
		cursorline = true,
		cursorcolumn = false,
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

	set_window_options(preview_win, {
		number = true,
		relativenumber = false,
		cursorline = true,
		wrap = false,
		scrolloff = 3,
		sidescrolloff = 4,
		signcolumn = "yes",
	})

	setup_keymaps(state, { list_buf, text_buf, preview_buf })

	state.augroup = vim.api.nvim_create_augroup("custom-diagnostics-" .. list_buf, { clear = true })

	vim.api.nvim_create_autocmd("CursorMoved", {
		buffer = list_buf,
		group = state.augroup,
		callback = function()
			if state.closed or state.normalizing then
				return
			end

			normalize_cursor(state)
			apply_list_highlights(state)
			render(state)
		end,
	})

	normalize_cursor(state)
	apply_list_highlights(state)
	render(state)
end

function M.open_document()
	local bufnr = vim.api.nvim_get_current_buf()
	local diagnostics = vim.diagnostic.get(bufnr)

	if vim.tbl_isempty(diagnostics) then
		open_picker(diagnostics)
		return
	end

	sort_diagnostics(diagnostics)

	local cursor = vim.api.nvim_win_get_cursor(0)
	local initial_index = find_nearest_diagnostic_index(diagnostics, bufnr, cursor[1] - 1, cursor[2])

	open_picker(diagnostics, {
		initial_index = initial_index,
		sorted = true,
	})
end

function M.open_workspace()
	open_picker(vim.diagnostic.get(nil))
end

return M
