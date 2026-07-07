local map = require("keymap.util").map

local M = {}

local function setup_document_highlight(event)
	local client = vim.lsp.get_client_by_id(event.data.client_id)

	if not client or not client:supports_method("textDocument/documentHighlight") then
		return
	end

	local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. event.buf, {
		clear = true,
	})

	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		group = group,
		buffer = event.buf,
		callback = function()
			vim.lsp.buf.document_highlight()
			require("ui.satellite-lsp-references").capture(event.buf)
		end,
	})

	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter" }, {
		group = group,
		buffer = event.buf,
		callback = function()
			vim.lsp.buf.clear_references()
			require("ui.satellite-lsp-references").clear(event.buf)
		end,
	})

	vim.api.nvim_create_autocmd("LspDetach", {
		group = group,
		buffer = event.buf,
		callback = function(detach_event)
			vim.lsp.buf.clear_references()
			require("ui.satellite-lsp-references").clear(detach_event.buf)
			vim.api.nvim_clear_autocmds({
				group = group,
				buffer = detach_event.buf,
			})
		end,
	})
end

local function setup_inlay_hints(event)
	local client = vim.lsp.get_client_by_id(event.data.client_id)

	if not client or not client:supports_method("textDocument/inlayHint") then
		return
	end

	vim.lsp.inlay_hint.enable(true, {
		bufnr = event.buf,
	})
end

local function setup_code_lens(event)
	local client = vim.lsp.get_client_by_id(event.data.client_id)

	if not client or not client:supports_method("textDocument/codeLens") then
		return
	end

	vim.lsp.codelens.enable(true, {
		bufnr = event.buf,
	})

	local group = vim.api.nvim_create_augroup("lsp_code_lens_" .. event.buf, {
		clear = true,
	})

	vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
		group = group,
		buffer = event.buf,
		callback = function()
			vim.lsp.codelens.enable(true, {
				bufnr = event.buf,
			})
		end,
	})

	vim.api.nvim_create_autocmd("LspDetach", {
		group = group,
		buffer = event.buf,
		callback = function(detach_event)
			vim.api.nvim_clear_autocmds({
				group = group,
				buffer = detach_event.buf,
			})
		end,
	})
end

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
	local client = vim.lsp.get_client_by_id(event.data.client_id)
	local opts = {
		buffer = event.buf,
	}
	local function map_supported(method, mode, lhs, rhs, desc)
		if client and client:supports_method(method) then
			map(mode, lhs, rhs, desc, opts)
		end
	end

	setup_document_highlight(event)
	setup_inlay_hints(event)
	setup_code_lens(event)

	map_supported("textDocument/definition", "n", "gd", function()
		open_fzf_lsp_picker("lsp_definitions")
	end, "Goto definition")
	map_supported("textDocument/declaration", "n", "gD", function()
		open_fzf_lsp_picker("lsp_declarations")
	end, "Goto declaration")
	map_supported("textDocument/typeDefinition", "n", "gI", function()
		open_fzf_lsp_picker("lsp_typedefs")
	end, "Goto type definition")
	map_supported("textDocument/implementation", "n", "gi", function()
		open_fzf_lsp_picker("lsp_implementations")
	end, "Goto implementation")
	map_supported("textDocument/references", "n", "gr", function()
		open_fzf_lsp_picker("lsp_references")
	end, "References")
	map_supported("textDocument/documentSymbol", "n", "<leader>co", function()
		open_fzf_lsp_picker("lsp_document_symbols")
	end, "Document symbols")
	map_supported("workspace/symbol", "n", "<leader>cw", function()
		open_fzf_lsp_picker("lsp_live_workspace_symbols")
	end, "Workspace symbols")
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
	map_supported("textDocument/hover", "n", "K", vim.lsp.buf.hover, "Hover")
	map_supported("textDocument/signatureHelp", "n", "<leader>cs", vim.lsp.buf.signature_help, "Signature help")
	map_supported("textDocument/rename", "n", "<leader>cr", vim.lsp.buf.rename, "Rename")
	map_supported("textDocument/prepareTypeHierarchy", "n", "<leader>cS", function()
		vim.lsp.buf.typehierarchy("supertypes")
	end, "Type hierarchy supertypes")
	map_supported("textDocument/prepareTypeHierarchy", "n", "<leader>cT", function()
		vim.lsp.buf.typehierarchy("subtypes")
	end, "Type hierarchy subtypes")
	map_supported("textDocument/prepareCallHierarchy", "n", "<leader>cI", vim.lsp.buf.incoming_calls, "Incoming calls")
	map_supported("textDocument/prepareCallHierarchy", "n", "<leader>cO", vim.lsp.buf.outgoing_calls, "Outgoing calls")
	map_supported("textDocument/codeLens", "n", "<leader>cL", vim.lsp.codelens.run, "Run code lens")
	map_supported("textDocument/codeLens", "n", "<leader>cR", function()
		vim.lsp.codelens.enable(true, {
			bufnr = event.buf,
		})
	end, "Refresh code lens")
	map_supported("textDocument/codeAction", "n", "<M-CR>", function()
		require("fzf-lua").lsp_code_actions({
			previewer = false,
		})
	end, "Code action")
	map_supported("textDocument/codeAction", { "n", "x" }, "<leader>ca", function()
		require("fzf-lua").lsp_code_actions({
			previewer = false,
		})
	end, "Code action")
end

function M.setup()
	map("n", "<leader>cd", function()
		require("ui.diagnostics").open_document()
	end, "Buffer diagnostics")
	map("n", "<leader>cq", vim.diagnostic.setloclist, "Diagnostics to location list")
	map({ "n", "x" }, "<leader>bf", format_buffer, "Format buffer")
	map("n", "<leader>cf", cleanup_buffer, "Clean up buffer")

	map("n", "<leader>cl", function()
		require("lint").try_lint()
	end, "Lint code")
end

return M
