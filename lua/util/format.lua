local M = {}

local extensions_by_ft = {
	bash = "sh",
	css = "css",
	html = "html",
	javascript = "js",
	javascriptreact = "jsx",
	json = "json",
	jsonc = "jsonc",
	lua = "lua",
	opentofu = "tf",
	["opentofu-vars"] = "tfvars",
	php = "php",
	sh = "sh",
	smarty = "tpl",
	sql = "sql",
	terraform = "tf",
	["terraform-vars"] = "tfvars",
	tf = "tf",
	typescript = "ts",
	typescriptreact = "tsx",
	yaml = "yaml",
}

local function notify(message, level)
	vim.notify(message, level or vim.log.levels.ERROR, {
		title = "Format selection",
	})
end

local function next_character_column(line, column)
	local next_column = math.min(column + 1, #line)

	while next_column < #line do
		local byte = line:byte(next_column + 1)

		if not byte or byte < 0x80 or byte > 0xBF then
			break
		end

		next_column = next_column + 1
	end

	return next_column
end

local function capture_selection()
	local mode = vim.fn.mode()

	if mode ~= "v" and mode ~= "V" then
		return nil, "Only characterwise and linewise selections can be formatted"
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local anchor = vim.fn.getpos("v")
	local cursor = vim.fn.getpos(".")
	local start_line = anchor[2]
	local start_column = anchor[3]
	local end_line = cursor[2]
	local end_column = cursor[3]

	if end_line < start_line or (end_line == start_line and end_column < start_column) then
		start_line, end_line = end_line, start_line
		start_column, end_column = end_column, start_column
	end

	local start_row = start_line - 1
	local end_row = end_line - 1
	local start_col = start_column - 1
	local start_line_text = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, true)[1] or ""
	local end_col

	if mode == "V" then
		start_col = 0
		end_col = #(vim.api.nvim_buf_get_lines(bufnr, end_row, end_row + 1, true)[1] or "")
	else
		local end_line_text = vim.api.nvim_buf_get_lines(bufnr, end_row, end_row + 1, true)[1] or ""
		end_col = next_character_column(end_line_text, end_column - 1)
	end

	return {
		bufnr = bufnr,
		changedtick = vim.api.nvim_buf_get_changedtick(bufnr),
		continuation_indent = start_line_text:match("^%s*") or "",
		filetype = vim.bo[bufnr].filetype,
		linewise = mode == "V",
		start_row = start_row,
		start_col = start_col,
		end_row = end_row,
		end_col = end_col,
		lines = vim.api.nvim_buf_get_text(bufnr, start_row, start_col, end_row, end_col, {}),
	}
end

local function common_indent(lines, skip_first)
	local indent

	for index, line in ipairs(lines) do
		if not (skip_first and index == 1) and line:find("%S") then
			local current = line:match("^%s*") or ""

			if not indent then
				indent = current
			else
				local length = math.min(#indent, #current)

				while length > 0 and indent:sub(1, length) ~= current:sub(1, length) do
					length = length - 1
				end

				indent = indent:sub(1, length)
			end
		end
	end

	return indent or ""
end

local function without_indent(lines, indent, skip_first)
	local result = {}

	for index, line in ipairs(lines) do
		if not (skip_first and index == 1) and indent ~= "" and line:sub(1, #indent) == indent then
			result[index] = line:sub(#indent + 1)
		else
			result[index] = line
		end
	end

	return result
end

local function with_indent(lines, indent, skip_first)
	local result = {}

	for index, line in ipairs(lines) do
		if not (skip_first and index == 1) and line:find("%S") then
			result[index] = indent .. line
		else
			result[index] = line
		end
	end

	return result
end

local function scratch_name(selection, scratch, filetype)
	local source_name = vim.api.nvim_buf_get_name(selection.bufnr)
	local directory = source_name ~= "" and vim.fs.dirname(source_name) or vim.fn.getcwd()
	local extension = extensions_by_ft[filetype] or filetype:gsub("[^%w]", "")

	return vim.fs.joinpath(directory, "nvim-format-selection-" .. scratch .. "." .. extension)
end

local function format_selection(selection, profile)
	if not vim.api.nvim_buf_is_valid(selection.bufnr) or not vim.api.nvim_buf_is_loaded(selection.bufnr) then
		notify("The source buffer is no longer available")
		return
	end

	if vim.api.nvim_buf_get_changedtick(selection.bufnr) ~= selection.changedtick then
		notify("The source buffer changed while the formatter picker was open")
		return
	end

	if not vim.bo[selection.bufnr].modifiable then
		notify("The source buffer is not modifiable")
		return
	end

	local skip_first_indent = not selection.linewise and selection.start_col > 0
	local indent = common_indent(selection.lines, skip_first_indent)

	if skip_first_indent and #selection.lines == 1 then
		indent = selection.continuation_indent
	end

	local input = without_indent(selection.lines, indent, skip_first_indent)
	local scratch = vim.api.nvim_create_buf(false, true)

	vim.bo[scratch].bufhidden = "wipe"
	vim.bo[scratch].buftype = "nofile"
	vim.bo[scratch].swapfile = false
	vim.bo[scratch].filetype = profile.filetype
	vim.bo[scratch].expandtab = vim.bo[selection.bufnr].expandtab
	vim.bo[scratch].fileformat = vim.bo[selection.bufnr].fileformat
	vim.bo[scratch].shiftwidth = vim.bo[selection.bufnr].shiftwidth
	vim.bo[scratch].softtabstop = vim.bo[selection.bufnr].softtabstop
	vim.bo[scratch].tabstop = vim.bo[selection.bufnr].tabstop
	vim.bo[scratch].textwidth = vim.bo[selection.bufnr].textwidth
	vim.api.nvim_buf_set_name(scratch, scratch_name(selection, scratch, profile.filetype))
	vim.api.nvim_buf_set_lines(scratch, 0, -1, true, input)

	local format_error

	local ok, call_error = pcall(require("conform").format, {
		async = false,
		bufnr = scratch,
		formatters = {
			profile.formatter,
		},
		lsp_format = "never",
		quiet = true,
		timeout_ms = 3000,
	}, function(err)
		format_error = err
	end)

	if not ok then
		format_error = tostring(call_error)
	end

	if format_error then
		pcall(vim.api.nvim_buf_delete, scratch, {
			force = true,
		})
		notify("Formatting with " .. profile.formatter .. " failed: " .. format_error)
		return
	end

	local output = vim.api.nvim_buf_get_lines(scratch, 0, -1, true)

	pcall(vim.api.nvim_buf_delete, scratch, {
		force = true,
	})

	if vim.api.nvim_buf_get_changedtick(selection.bufnr) ~= selection.changedtick then
		notify("The source buffer changed while the selection was being formatted")
		return
	end

	local replacement = with_indent(output, indent, skip_first_indent)

	if vim.deep_equal(replacement, selection.lines) then
		return
	end

	vim.api.nvim_buf_set_text(
		selection.bufnr,
		selection.start_row,
		selection.start_col,
		selection.end_row,
		selection.end_col,
		replacement
	)
end

local function formatter_profiles(bufnr, current_filetype)
	local conform = require("conform")
	local profiles = {}
	local seen = {}

	for filetype, configured in pairs(conform.formatters_by_ft) do
		if type(configured) == "table" then
			for order, formatter in ipairs(configured) do
				local key = filetype .. "\0" .. formatter
				local info = conform.get_formatter_info(formatter, bufnr)

				if not seen[key] and info.available then
					seen[key] = true
					table.insert(profiles, {
						current = filetype == current_filetype,
						filetype = filetype,
						formatter = formatter,
						order = order,
					})
				end
			end
		end
	end

	table.sort(profiles, function(left, right)
		if left.current ~= right.current then
			return left.current
		end

		if left.filetype ~= right.filetype then
			return left.filetype < right.filetype
		end

		return left.order < right.order
	end)

	return profiles
end

local function open_formatter_picker(selection)
	local profiles = formatter_profiles(selection.bufnr, selection.filetype)

	if vim.tbl_isempty(profiles) then
		notify("No configured formatter is available", vim.log.levels.WARN)
		return
	end

	local entries = {}

	for index, profile in ipairs(profiles) do
		entries[index] = string.format("%d\t%-20s %s", index, profile.filetype, profile.formatter)
	end

	require("fzf-lua").fzf_exec(entries, {
		actions = {
			["enter"] = function(selected)
				local index = selected and selected[1] and tonumber(selected[1]:match("^(%d+)"))
				local profile = index and profiles[index]

				if profile then
					format_selection(selection, profile)
				end
			end,
		},
		fzf_opts = {
			["--delimiter"] = "[\t]",
			["--no-multi"] = true,
			["--with-nth"] = "2..",
		},
		previewer = false,
		prompt = "Search> ",
		winopts = {
			title = " Format selection ",
			title_flags = false,
		},
	})
end

function M.buffer()
	require("conform").format({
		async = true,
		lsp_format = "fallback",
	})
end

function M.selection()
	local selection, err = capture_selection()

	if not selection then
		notify(err)
		return
	end

	open_formatter_picker(selection)
end

return M
