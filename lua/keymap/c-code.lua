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
		buf = event.buf,
		callback = function()
			require("ui.satellite-lsp-references").highlight(event.buf)
		end,
	})

	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter" }, {
		group = group,
		buf = event.buf,
		callback = function()
			require("ui.satellite-lsp-references").clear(event.buf)
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

local function resolve_code_action(client, bufnr, action, timeout_ms)
	if action.edit or action.command then
		return action
	end

	if not client:supports_method("codeAction/resolve") then
		return action
	end

	local response = client:request_sync("codeAction/resolve", action, timeout_ms, bufnr)

	if response and response.result then
		return response.result
	end

	return action
end

local function run_code_action_sync(action_spec, timeout_ms)
	local bufnr = vim.api.nvim_get_current_buf()
	local last_line = vim.api.nvim_buf_line_count(bufnr)
	local last_line_text = vim.api.nvim_buf_get_lines(bufnr, last_line - 1, last_line, false)[1] or ""

	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if
			client:supports_method("textDocument/codeAction", bufnr)
			and (not action_spec.client or client.name == action_spec.client)
		then
			---@type lsp.CodeActionParams
			local params = {
				textDocument = vim.lsp.util.make_text_document_params(bufnr),
				range = {
					start = {
						line = 0,
						character = 0,
					},
					["end"] = {
						line = math.max(last_line - 1, 0),
						character = vim.str_utfindex(last_line_text, client.offset_encoding),
					},
				},
				context = {
					only = {
						action_spec.kind,
					},
					diagnostics = {},
				},
			}
			local response = client:request_sync("textDocument/codeAction", params, timeout_ms, bufnr)

			for _, action in pairs((response and response.result) or {}) do
				local resolved_action = resolve_code_action(client, bufnr, action, timeout_ms)

				if resolved_action.edit then
					vim.lsp.util.apply_workspace_edit(resolved_action.edit, client.offset_encoding)
				end

				local command = resolved_action.command

				if command then
					client:exec_cmd(type(command) == "table" and command or resolved_action, {
						bufnr = bufnr,
						client_id = client.id,
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

local function visual_range(bufnr)
	local mode = vim.fn.mode()
	local anchor = vim.fn.getpos("v")
	local cursor = vim.fn.getpos(".")
	local start_line = anchor[2]
	local start_column = anchor[3]
	local end_line = cursor[2]
	local end_column = cursor[3]

	if start_line == end_line and end_column < start_column then
		start_column, end_column = end_column, start_column
	elseif end_line < start_line then
		start_line, end_line = end_line, start_line
		start_column, end_column = end_column, start_column
	end

	if mode == "V" then
		start_column = 1
		local end_line_text = vim.api.nvim_buf_get_lines(bufnr, end_line - 1, end_line, true)[1] or ""
		end_column = #end_line_text + 1
	end

	return {
		start = {
			start_line,
			start_column - 1,
		},
		["end"] = {
			end_line,
			end_column - 1,
		},
	}
end

local function format_visual_selection()
	local conform = require("conform")
	local bufnr = vim.api.nvim_get_current_buf()
	local range = visual_range(bufnr)
	local choices = {}

	for _, formatter in ipairs(conform.list_formatters(bufnr)) do
		table.insert(choices, {
			kind = "conform",
			label = formatter.name,
			name = formatter.name,
		})
	end

	for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if client:supports_method("textDocument/rangeFormatting", bufnr) then
			table.insert(choices, {
				kind = "lsp",
				label = client.name .. " (LSP)",
				name = client.name,
			})
		end
	end

	if #choices == 0 then
		vim.notify("No formatter available for " .. vim.bo[bufnr].filetype, vim.log.levels.WARN)
		return
	end

	vim.ui.select(choices, {
		prompt = "Formatter> ",
		format_item = function(choice)
			return choice.label
		end,
	}, function(choice)
		if not choice then
			return
		end

		if choice.kind == "lsp" then
			conform.format({
				async = true,
				bufnr = bufnr,
				lsp_format = "prefer",
				name = choice.name,
				range = range,
			})
			return
		end

		conform.format({
			async = true,
			bufnr = bufnr,
			formatters = {
				choice.name,
			},
			lsp_format = "never",
			range = range,
		})
	end)
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
		buf = event.buf,
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
		})
	end, "Next diagnostic", opts)
	map("n", "[d", function()
		vim.diagnostic.jump({
			count = -1,
		})
	end, "Previous diagnostic", opts)
	map_supported("textDocument/hover", "n", "K", function()
		vim.lsp.buf.hover(require("ui.lsp_float").config())
	end, "Hover")
	map_supported("textDocument/signatureHelp", "n", "<leader>cs", function()
		vim.lsp.buf.signature_help(require("ui.lsp_float").config())
	end, "Signature help")
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
	map("n", "<leader>bf", format_buffer, "Format buffer")
	map("x", "<leader>bf", format_visual_selection, "Format selected lines")
	map("n", "<leader>cf", cleanup_buffer, "Clean up buffer")

	map("n", "<leader>cl", function()
		require("lint").try_lint()
	end, "Lint code")
end

return M
