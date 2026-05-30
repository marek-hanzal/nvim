return {
	{
		"lewis6991/satellite.nvim",
		event = {
			"BufReadPost",
			"BufNewFile",
		},
		config = function(_, opts)
			local util = require("satellite.util")
			local row_to_barpos = util.row_to_barpos

			util.row_to_barpos = function(winid, row)
				if not vim.api.nvim_win_is_valid(winid) or util.get_winheight(winid) <= 1 then
					return 0, 0
				end

				local pos, fraction = row_to_barpos(winid, row)

				if type(pos) ~= "number" or pos ~= pos or pos == math.huge or pos == -math.huge then
					return 0, 0
				end

				if pos < 0 then
					pos = 0
				end

				return math.floor(pos), fraction
			end

			require("ui.satellite-lsp-references").register()
			require("satellite").setup(opts)
		end,
		opts = {
			current_only = false,
			winblend = 0,
			handlers = {
				cursor = {
					enable = true,
				},
				search = {
					enable = true,
				},
				diagnostic = {
					enable = true,
				},
				gitsigns = {
					enable = true,
				},
				lsp_references = {
					enable = true,
					overlap = true,
					priority = 25,
				},
			},
		},
	},
}
