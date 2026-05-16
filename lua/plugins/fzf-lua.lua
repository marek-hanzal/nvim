return {
	{
		"ibhagwan/fzf-lua",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			winopts = {
				height = 0.85,
				width = 0.85,

				preview = {
					layout = "flex",
					hidden = false,
				},
			},

			grep = {
				rg_opts = table.concat({
					"--column",
					"--line-number",
					"--no-heading",
					"--color=always",
					"--smart-case",
					"--hidden",
					"--no-ignore-vcs",
				}, " "),
			},
		},
		config = function(_, opts)
			local fzf = require("fzf-lua")
			local actions = require("fzf-lua.actions")
			local path = require("fzf-lua.path")
			local neotree = require("neo-tree.command")
			local filesystem_commands = require("neo-tree.sources.filesystem.commands")
			local manager = require("neo-tree.sources.manager")
			local renderer = require("neo-tree.ui.renderer")
			local nt_utils = require("neo-tree.utils")
			local uv = vim.uv or vim.loop

			local function smart_file_or_dir(selected, picker_opts)
				if not selected or not selected[1] then
					return
				end

				local entry = path.entry_to_file(selected[1], picker_opts)
				local target = entry and entry.path

				if not target then
					return
				end

				local stat = uv.fs_stat(target)
				if not (stat and stat.type == "directory") then
					actions.file_edit(selected, picker_opts)
					return
				end

				local node_id = nt_utils.remove_trailing_slash(vim.fs.normalize(target))

				neotree.execute({
					action = "focus",
					source = "filesystem",
				})

				local state = manager.get_state("filesystem")
				---@cast state neotree.sources.filesystem.State

				manager.navigate(state, state.path or manager.get_cwd(state), node_id, function()
					if not renderer.focus_node(state, node_id) then
						return
					end

					filesystem_commands.open(state)
					renderer.focus_node(state, node_id)
				end)
			end

			opts.files = vim.tbl_deep_extend("force", opts.files or {}, {
				fd_opts = table.concat({
					"--color=never",
					"--type f",
					"--type d",
					"--type l",
					"--hidden",
					"--no-ignore-vcs",
				}, " "),
				actions = {
					["enter"] = smart_file_or_dir,
				},
			})

			fzf.setup(opts)
			fzf.register_ui_select()
		end,
	},
}
