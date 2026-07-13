local api = vim.api

local M = {}

local method = "textDocument/documentHighlight"
local defaults = {
	enable = true,
	overlap = true,
	priority = 25,
	symbols = {
		[1] = "",
		[2] = "",
		[3] = "",
	},
}

local highlights = {
	[1] = "SatelliteLspReferenceText",
	[2] = "SatelliteLspReferenceRead",
	[3] = "SatelliteLspReferenceWrite",
}

local cache = {}
local generations = {}
local pending = {}

local function is_valid_mark_pos(pos)
	return type(pos) == "number" and pos == pos and pos ~= math.huge and pos ~= -math.huge and pos >= 0 and pos % 1 == 0
end

local function refresh_satellite()
	local ok, view = pcall(require, "satellite.view")

	if ok then
		view.schedule_refresh()
	end
end

local function cancel_pending(bufnr)
	if pending[bufnr] then
		pending[bufnr]()
		pending[bufnr] = nil
	end
end

function M.clear(bufnr)
	generations[bufnr] = (generations[bufnr] or 0) + 1
	cancel_pending(bufnr)
	cache[bufnr] = nil
	vim.lsp.util.buf_clear_references(bufnr)
	refresh_satellite()
end

function M.highlight(bufnr)
	if not api.nvim_buf_is_valid(bufnr) or #vim.lsp.get_clients({ bufnr = bufnr, method = method }) == 0 then
		M.clear(bufnr)
		return
	end

	local winid = vim.fn.bufwinid(bufnr)
	local generation = (generations[bufnr] or 0) + 1

	generations[bufnr] = generation
	cancel_pending(bufnr)

	if winid == -1 then
		return
	end

	local cursor = api.nvim_win_get_cursor(winid)
	local changedtick = vim.b[bufnr].changedtick

	pending[bufnr] = vim.lsp.buf_request_all(bufnr, method, function(client)
		return vim.lsp.util.make_position_params(winid, client.offset_encoding)
	end, function(results)
		pending[bufnr] = nil

		if
			generations[bufnr] ~= generation
			or not api.nvim_buf_is_valid(bufnr)
			or not api.nvim_win_is_valid(winid)
			or api.nvim_win_get_buf(winid) ~= bufnr
			or vim.b[bufnr].changedtick ~= changedtick
			or not vim.deep_equal(api.nvim_win_get_cursor(winid), cursor)
		then
			return
		end

		local lines = {}

		vim.lsp.util.buf_clear_references(bufnr)

		for client_id, response in pairs(results) do
			local client = vim.lsp.get_client_by_id(client_id)

			if client and not response.error and response.result then
				vim.lsp.util.buf_highlight_references(bufnr, response.result, client.offset_encoding)

				for _, reference in ipairs(response.result) do
					local line = reference.range.start.line
					local kind = reference.kind or 1

					lines[line] = math.max(lines[line] or 0, kind)
				end
			end
		end

		cache[bufnr] = next(lines) and lines or nil
		refresh_satellite()
	end)
end

function M.register()
	if M._registered then
		return
	end

	M._registered = true

	local handler = {
		name = "lsp_references",
	}

	function handler.setup(config)
		handler.config = vim.tbl_deep_extend("force", defaults, config or {})
		M.config = handler.config
	end

	function handler.update(bufnr, winid)
		local util = require("satellite.util")
		local marks_by_pos = {}
		local lines = cache[bufnr]

		if not lines or not api.nvim_win_is_valid(winid) or util.get_winheight(winid) <= 1 then
			return {}
		end

		for line, kind in pairs(lines) do
			local pos = util.row_to_barpos(winid, line)
			local existing = marks_by_pos[pos]

			if is_valid_mark_pos(pos) and (not existing or kind > existing.kind) then
				marks_by_pos[pos] = {
					kind = kind,
				}
			end
		end

		local marks = {}

		for pos, mark in pairs(marks_by_pos) do
			marks[#marks + 1] = {
				pos = pos,
				highlight = highlights[mark.kind] or highlights[1],
				symbol = (M.config and M.config.symbols and M.config.symbols[mark.kind]) or defaults.symbols[mark.kind],
				unique = mark.kind == 3,
			}
		end

		return marks
	end

	require("satellite.handlers").register(handler)
end

return M
