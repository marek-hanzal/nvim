local function format_buffer()
	require("conform").format({
		async = true,
		lsp_format = "fallback",
	})
end

local function run_code_action_sync(kind, timeout_ms)
	local bufnr = vim.api.nvim_get_current_buf()
	local range_params = vim.lsp.util.make_range_params(0, "utf-16")
	---@type lsp.CodeActionParams
	local params = {
		textDocument = range_params.textDocument,
		range = range_params.range,
		context = {
			only = {
				kind,
			},
			diagnostics = vim.diagnostic.get(bufnr),
		},
	}

	local results = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, timeout_ms)

	if not results then
		return
	end

	for client_id, result in pairs(results) do
		local client = vim.lsp.get_client_by_id(client_id)

		for _, action in pairs(result.result or {}) do
			if client then
				if action.edit then
					vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
				end

				local command = action.command

				if command then
					client:exec_cmd(type(command) == "table" and command or action, {
						bufnr = bufnr,
						client_id = client_id,
					})
				end
			end
		end
	end
end

local function cleanup_buffer()
	local kinds = {
		"source.removeUnusedImports.ts",
		"source.organizeImports.ts",
	}

	for _, kind in ipairs(kinds) do
		run_code_action_sync(kind, 1000)
	end

	format_buffer()
end

return {
	{
		"stevearc/conform.nvim",
		cmd = {
			"ConformInfo",
		},
		keys = {
			{
				"<leader>bf",
				format_buffer,
				mode = {
					"n",
					"x",
				},
				desc = "Format buffer",
			},
			{
				"<leader>cf",
				cleanup_buffer,
				mode = "n",
				desc = "Clean up buffer",
			},
		},
		opts = {
			notify_on_error = true,
			notify_no_formatters = false,

			formatters_by_ft = {
				lua = {
					"stylua",
				},

				javascript = {
					"biome",
				},
				javascriptreact = {
					"biome",
				},
				typescript = {
					"biome",
				},
				typescriptreact = {
					"biome",
				},

				json = {
					"biome",
				},
				jsonc = {
					"biome",
				},

				css = {
					"biome",
				},
			},
		},
	},
}
