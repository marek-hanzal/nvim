local function get_snippet_paths()
	local paths = {
		vim.fn.stdpath("config") .. "/snippets",
	}

	local project_snippets = vim.fn.getcwd() .. "/.snippets"

	if vim.uv.fs_stat(project_snippets) then
		table.insert(paths, project_snippets)
	end

	return paths
end

return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",

		build = "make install_jsregexp",

		event = {
			"InsertEnter",
		},

		config = function()
			require("luasnip").config.setup({
				history = true,
				delete_check_events = "TextChanged",
				region_check_events = "CursorMoved,CursorMovedI",
			})

			require("luasnip.loaders.from_lua").lazy_load({
				paths = get_snippet_paths(),
			})
		end,
	},
}
