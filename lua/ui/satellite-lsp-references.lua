local api = vim.api

local M = {}

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

local function is_valid_mark_pos(pos)
	return type(pos) == "number" and pos == pos and pos ~= math.huge and pos ~= -math.huge and pos >= 0 and pos % 1 == 0
end

local function refresh_satellite()
	local ok, view = pcall(require, "satellite.view")

	if ok then
		view.schedule_refresh()
	end
end

local function supported_client_exists(bufnr)
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if client:supports_method("textDocument/documentHighlight") then
			return true
		end
	end

	return false
end

local function get_client_position_encoding(client)
	return client.position_encoding or client.offset_encoding or "utf-16"
end

function M.clear(bufnr)
	cache[bufnr] = nil
	refresh_satellite()
end

function M.capture(bufnr)
	if not api.nvim_buf_is_valid(bufnr) or not supported_client_exists(bufnr) then
		M.clear(bufnr)
		return
	end

	local lines = {}

	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if client:supports_method("textDocument/documentHighlight") then
			local params = vim.lsp.util.make_position_params(0, get_client_position_encoding(client))
			local response = client:request_sync("textDocument/documentHighlight", params, 200, bufnr)

			for _, highlight in ipairs((response and response.result) or {}) do
				local lnum = highlight.range.start.line
				local kind = highlight.kind or 1

				lines[lnum] = math.max(lines[lnum] or 0, kind)
			end
		end
	end

	cache[bufnr] = next(lines) and lines or nil
	refresh_satellite()
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

		for lnum, kind in pairs(lines) do
			local pos = util.row_to_barpos(winid, lnum)
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
