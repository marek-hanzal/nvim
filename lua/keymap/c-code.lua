local map = require("keymap.util").map

local M = {}

local cleanup_kinds_by_ft = {
	javascript = {
		"source.removeUnusedImports.ts",
		"source.organizeImports.ts",
	},
	javascriptreact = {
		"source.removeUnusedImports.ts",
		"source.organizeImports.ts",
	},
	typescript = {
		"source.removeUnusedImports.ts",
		"source.organizeImports.ts",
	},
	typescriptreact = {
		"source.removeUnusedImports.ts",
		"source.organizeImports.ts",
	},
}

local function get_position_encoding(bufnr)
	local clients = vim.lsp.get_clients({
		bufnr = bufnr,
	})

	for _, client in ipairs(clients) do
		if client.offset_encoding then
			return client.offset_encoding
		end
	end

	return "utf-16"
end

local function run_code_action_sync(kind, timeout_ms)
	local bufnr = vim.api.nvim_get_current_buf()
	local position_encoding = get_position_encoding(bufnr)
	local range_params = vim.lsp.util.make_range_params(0, position_encoding)
	---@type lsp.CodeActionParams
	local params = {
		textDocument = range_params.textDocument,
		range = range_params.range,
		context = {
			only = {
				kind,
			},
			diagnostics = {},
		},
	}

	local results = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, timeout_ms)

	if not results then
		return
	end

	for client_id, result in pairs(results) do
		local client = vim.lsp.get_client_by_id(client_id)

		if client then
			for _, action in pairs(result.result or {}) do
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

local function format_buffer()
	require("conform").format({
		async = true,
		lsp_format = "fallback",
	})
end

local function cleanup_buffer()
	local kinds = cleanup_kinds_by_ft[vim.bo.filetype] or {}

	for _, kind in ipairs(kinds) do
		run_code_action_sync(kind, 1000)
	end

	format_buffer()
end

function M.on_lsp_attach(event)
	local opts = {
		buffer = event.buf,
	}

	map("n", "gd", vim.lsp.buf.definition, "Goto definition", opts)
	map("n", "gD", vim.lsp.buf.declaration, "Goto declaration", opts)
	map("n", "gI", vim.lsp.buf.type_definition, "Goto type definition", opts)
	map("n", "gi", vim.lsp.buf.implementation, "Goto implementation", opts)
	map("n", "gr", vim.lsp.buf.references, "References", opts)
	map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic", opts)
	map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic", opts)
	map("n", "K", vim.lsp.buf.hover, "Hover", opts)
	map("n", "<leader>cs", vim.lsp.buf.signature_help, "Signature help", opts)
	map("n", "<leader>cr", vim.lsp.buf.rename, "Rename", opts)
	map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action", opts)
end

function M.setup()
	map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostic")
	map("n", "<leader>cq", vim.diagnostic.setloclist, "Diagnostics to location list")
	map({ "n", "x" }, "<leader>bf", format_buffer, "Format buffer")
	map("n", "<leader>cf", cleanup_buffer, "Clean up buffer")

	map("n", "<leader>cl", function()
		require("lint").try_lint()
	end, "Lint code")
end

return M
