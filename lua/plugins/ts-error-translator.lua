return {
	{
        -- This one is interesting, but I'm not sure if I'll keep
        -- it here. It makes TS errors a bit nicer, but I'm not sure
        -- if it's worth having an another plugin.

		"dmmulroy/ts-error-translator.nvim",

		ft = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},

		opts = {
			auto_attach = true,

			servers = {
				"ts_ls",
			},
		},
	},
}
