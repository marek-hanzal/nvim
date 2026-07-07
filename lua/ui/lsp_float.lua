local M = {}

local border = {
	{ "╭", "LspFloatBorder" },
	{ "─", "LspFloatBorder" },
	{ "╮", "LspFloatBorder" },
	{ "│", "LspFloatBorder" },
	{ "╯", "LspFloatBorder" },
	{ "─", "LspFloatBorder" },
	{ "╰", "LspFloatBorder" },
	{ "│", "LspFloatBorder" },
}

function M.config(opts)
	return vim.tbl_deep_extend("force", {
		border = border,
		focusable = true,
		max_width = math.floor(vim.o.columns * 0.6),
		max_height = math.floor(vim.o.lines * 0.5),
		zindex = 80,
	}, opts or {})
end

return M
