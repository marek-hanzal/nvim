return {
	{
		"nvim-mini/mini.ai",
		version = "*",
		event = "VeryLazy",

		config = function()
			require("mini.ai").setup({
				n_lines = 500,
				mappings = {
					around_next = "aN",
					inside_next = "iN",
					around_last = "aL",
					inside_last = "iL",
				},
			})
		end,
	},
}
