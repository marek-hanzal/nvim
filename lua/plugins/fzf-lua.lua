return {
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
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

			files = {
				fd_opts = table.concat({
					"--color=never",
					"--type f",
					"--type l",
					"--hidden",
					"--no-ignore-vcs",
				}, " "),
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
			local filesystem = require("neo-tree.sources.filesystem")
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

				if stat and stat.type == "directory" then
					local node_id = nt_utils.remove_trailing_slash(vim.fs.normalize(target))

					require("neo-tree.command").execute({
						action = "focus",
						source = "filesystem",
					})

					vim.schedule(function()
						local state = manager.get_state("filesystem")
						local root = state.path or manager.get_cwd(state)

						manager.navigate(state, root, node_id, function()
							local focused = renderer.focus_node(state, node_id)
							local node = focused and state.tree and state.tree:get_node(node_id)

							if node and node.type == "directory" and not node:is_expanded() then
								filesystem.toggle_directory(state, node, nil, false)
								renderer.focus_node(state, node_id)
							end
						end)
					end)

					return
				end

				actions.file_edit(selected, picker_opts)
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
