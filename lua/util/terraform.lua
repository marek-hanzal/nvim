local M = {}

local function current_dir()
	return vim.uv.cwd()
end

local function split_args(args)
	if not args or args == "" then
		return {}
	end

	return vim.fn.split(args)
end

local function executable(name)
	return name and name ~= "" and vim.fn.executable(name) == 1
end

local function notify_missing(command, install_hint)
	vim.notify(command .. " executable not found" .. install_hint, vim.log.levels.ERROR)
end

local function run_terminal(cmd, opts)
	opts = opts or {}

	local cwd = opts.cwd or current_dir()
	local height = opts.height or 15

	vim.cmd("botright " .. height .. "split")
	vim.cmd("lcd " .. vim.fn.fnameescape(cwd))

	local job = vim.fn.termopen(cmd, {
		cwd = cwd,
	})

	if job <= 0 then
		vim.notify("Failed to start: " .. table.concat(cmd, " "), vim.log.levels.ERROR)
		return
	end

	vim.cmd("startinsert")
end

function M.terraform_bin()
	if executable(vim.env.NVIM_TERRAFORM_BIN) then
		return vim.env.NVIM_TERRAFORM_BIN
	end

	if executable("terraform") then
		return "terraform"
	end

	if executable("tofu") then
		return "tofu"
	end

	return nil
end

function M.tflint_root()
	return current_dir()
end

function M.run_terraform(args, opts)
	local bin = M.terraform_bin()

	if not bin then
		notify_missing("terraform/tofu", "; install Terraform, OpenTofu, or set NVIM_TERRAFORM_BIN")
		return
	end

	local cmd = {
		bin,
	}

	vim.list_extend(cmd, args)
	run_terminal(cmd, opts)
end

function M.init(args)
	M.run_terraform(vim.list_extend({
		"init",
	}, split_args(args)))
end

function M.validate(args)
	M.run_terraform(vim.list_extend({
		"validate",
		"-no-color",
	}, split_args(args)))
end

function M.plan(args)
	M.run_terraform(
		vim.list_extend({
			"plan",
			"-no-color",
		}, split_args(args)),
		{
			height = 20,
		}
	)
end

function M.fmt(args)
	M.run_terraform(vim.list_extend({
		"fmt",
		"-recursive",
	}, split_args(args)))
end

function M.workspace_list()
	M.run_terraform({
		"workspace",
		"list",
	})
end

function M.workspace_select(name)
	if name and name ~= "" then
		M.run_terraform({
			"workspace",
			"select",
			name,
		})
		return
	end

	vim.ui.input({
		prompt = "Terraform workspace: ",
	}, function(input)
		if input and input ~= "" then
			M.workspace_select(input)
		end
	end)
end

function M.tflint(args)
	if not executable("tflint") then
		notify_missing("tflint", "; Mason should install it on next startup")
		return
	end

	local cmd = {
		"tflint",
		"--recursive",
	}

	vim.list_extend(cmd, split_args(args))
	run_terminal(cmd, {
		cwd = M.tflint_root(),
	})
end

function M.trivy(args)
	if not executable("trivy") then
		notify_missing("trivy", "; Mason should install it on next startup")
		return
	end

	local cmd = {
		"trivy",
		"config",
		".",
	}

	vim.list_extend(cmd, split_args(args))
	run_terminal(cmd, {
		height = 20,
	})
end

return M
