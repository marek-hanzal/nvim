local M = {}

function M.map(mode, lhs, rhs, desc, opts)
	assert(type(desc) == "string" and desc ~= "", "Keymap description is required for " .. lhs)

	opts = opts or {}
	opts.desc = desc

	vim.keymap.set(mode, lhs, rhs, opts)
end

return M
