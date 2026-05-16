local map = require("keymap.util").map

local M = {}

local cleanup_kinds_by_ft = {
	javascript = {
		{
			kind = "source.removeUnusedImports.ts",
			client = "ts_ls",
		},
		{
			kind = "source.organizeImports.biome",
			client = "biome",
		},
	},
	javascriptreact = {
		{
			kind = "source.removeUnusedImports.ts",
			client = "ts_ls",
		},
		{
			kind = "source.organizeImports.biome",
			client = "biome",
		},
	},
	typescript = {
		{
			kind = "source.removeUnusedImports.ts",
			client = "ts_ls",
		},
		{
			kind = "source.organizeImports.biome",
			client = "biome",
		},
	},
	typescriptreact = {
		{
			kind = "source.removeUnusedImports.ts",
			client = "ts_ls",
		},
		{
			kind = "source.organizeImports.biome",
			client = "biome",
		},
	},
}

local function resolve_code_action(client, action, timeout_ms)
	if action.edit or action.command then
		return action
	end

	if not client:supports_method("codeAction/resolve") then
		return action
	end

	local response = client:request_sync("codeAction/resolve", action, timeout_ms, 0)

	if response and response.result then
		return response.result
	end

	return action
end

local function run_code_action_sync(action_spec, timeout_ms)
	local bufnr = vim.api.nvim_get_current_buf()
	local last_line = vim.api.nvim_buf_line_count(bufnr)
	local last_line_text = vim.api.nvim_buf_get_lines(bufnr, last_line - 1, last_line, false)[1] or ""
	local kind = action_spec.kind
	local range_params = {
		textDocument = vim.lsp.util.make_text_document_params(bufnr),
		range = {
			start = {
				line = 0,
				character = 0,
			},
			["end"] = {
				line = math.max(last_line - 1, 0),
				character = vim.str_utfindex(last_line_text),
			},
		},
	}

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

		if client and (not action_spec.client or client.name == action_spec.client) then
			for _, action in pairs(result.result or {}) do
				local resolved_action = resolve_code_action(client, action, timeout_ms)

				if resolved_action.edit then
					vim.lsp.util.apply_workspace_edit(resolved_action.edit, client.offset_encoding)
				end

				local command = resolved_action.command

				if command then
					client:exec_cmd(type(command) == "table" and command or resolved_action, {
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

local function open_fzf_lsp_picker(picker, opts)
	---@diagnostic disable-next-line: param-type-mismatch
	require("fzf-lua")[picker](vim.tbl_deep_extend("force", {
		jump1 = true,
		previewer = true,
	}, opts or {}))
end

local function cleanup_buffer()
	local action_specs = cleanup_kinds_by_ft[vim.bo.filetype] or {}

	for _, action_spec in ipairs(action_specs) do
		run_code_action_sync(action_spec, 1000)
	end

	format_buffer()
end

function M.on_lsp_attach(event)
	local opts = {
		buffer = event.buf,
	}

	map("n", "gd", function()
		open_fzf_lsp_picker("lsp_definitions")
	end, "Goto definition", opts)
	map("n", "gD", function()
		open_fzf_lsp_picker("lsp_declarations")
	end, "Goto declaration", opts)
	map("n", "gI", function()
		open_fzf_lsp_picker("lsp_typedefs")
	end, "Goto type definition", opts)
	map("n", "gi", function()
		open_fzf_lsp_picker("lsp_implementations")
	end, "Goto implementation", opts)
	map("n", "gr", function()
		open_fzf_lsp_picker("lsp_references")
	end, "References", opts)
	map("n", "]d", function()
		vim.diagnostic.jump({
			count = 1,
			float = false,
		})
	end, "Next diagnostic", opts)
	map("n", "[d", function()
		vim.diagnostic.jump({
			count = -1,
			float = false,
		})
	end, "Previous diagnostic", opts)
	map("n", "K", vim.lsp.buf.hover, "Hover", opts)
	map("n", "<leader>cs", vim.lsp.buf.signature_help, "Signature help", opts)
	map("n", "<leader>cr", vim.lsp.buf.rename, "Rename", opts)
	map("n", "<M-CR>", function()
		require("fzf-lua").lsp_code_actions({
			previewer = false,
		})
	end, "Code action", opts)
	map({ "n", "x" }, "<leader>ca", function()
		require("fzf-lua").lsp_code_actions({
			previewer = false,
		})
	end, "Code action", opts)
end

function M.setup()
	map("n", "<leader>cd", function()
		require("fzf-lua").diagnostics_document({
			sort = true,
			fzf_opts = {
				["--no-input"] = true,
			},
			winopts = {
				preview = {
					hidden = false,
				},
			},
		})
	end, "Buffer diagnostics")
	map("n", "<leader>cq", vim.diagnostic.setloclist, "Diagnostics to location list")
	map({ "n", "x" }, "<leader>bf", format_buffer, "Format buffer")
	map("n", "<leader>cf", cleanup_buffer, "Clean up buffer")

	map("n", "<leader>cl", function()
		require("lint").try_lint()
	end, "Lint code")
end

return M
