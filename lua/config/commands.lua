vim.api.nvim_create_user_command("BufferPrune", function()
	require("util.buffer_prune").prune()
end, {
	desc = "Delete hidden least-recently-used file buffers past the configured limit",
})

vim.api.nvim_create_user_command("TagsGenerate", function()
	if vim.fn.executable("ctags") ~= 1 then
		vim.notify("ctags executable not found", vim.log.levels.ERROR)
		return
	end

	local version = table.concat(
		vim.fn.systemlist({
			"ctags",
			"--version",
		}),
		"\n"
	)

	if vim.v.shell_error ~= 0 or not version:find("Universal Ctags", 1, true) then
		vim.notify("Universal Ctags not found; install it with brew install universal-ctags", vim.log.levels.ERROR)
		return
	end

	local cwd = vim.uv.cwd()
	local root = vim.fs.root(cwd, {
		".git",
		"package.json",
		"composer.json",
		"stylua.toml",
		".luarc.json",
	}) or cwd

	local cmd = {
		"ctags",
		"-R",
		"--tag-relative=yes",
		"--fields=+iaS",
		"--extras=+q",
		"--exclude=.git",
		"--exclude=node_modules",
		"--exclude=dist",
		"--exclude=build",
		"--exclude=.next",
		"--exclude=coverage",
		"--exclude=vendor",
		"-f",
		"tags",
		".",
	}

	vim.notify("Generating tags in " .. vim.fn.fnamemodify(root, ":~"), vim.log.levels.INFO)

	vim.system(cmd, {
		cwd = root,
		text = true,
	}, function(result)
		vim.schedule(function()
			if result.code == 0 then
				vim.notify("Generated tags in " .. vim.fn.fnamemodify(root, ":~"), vim.log.levels.INFO)
				return
			end

			local message = vim.trim(result.stderr or result.stdout or "ctags failed")
			vim.notify(message, vim.log.levels.ERROR)
		end)
	end)
end, {
	desc = "Generate Universal Ctags index for the current project",
})
