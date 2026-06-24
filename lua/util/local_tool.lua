local M = {}

local function config_root()
	local source = debug.getinfo(1, "S").source:sub(2)

	return vim.fs.dirname(vim.fs.dirname(vim.fs.dirname(source)))
end

function M.bin(name)
	local extension = vim.uv.os_uname().sysname == "Windows_NT" and ".cmd" or ""
	local path = vim.fs.joinpath(config_root(), "node_modules", ".bin", name .. extension)

	if vim.uv.fs_stat(path) then
		return path
	end

	return name
end

return M
