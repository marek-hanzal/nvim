local map = require("keymap.util").map

local M = {}

function M.setup()
	local terraform = require("util.terraform")

	map("n", "<leader>ii", function()
		terraform.init()
	end, "Terraform init")

	map("n", "<leader>iv", function()
		terraform.validate()
	end, "Terraform validate")

	map("n", "<leader>ip", function()
		terraform.plan()
	end, "Terraform plan")

	map("n", "<leader>if", function()
		terraform.fmt()
	end, "Terraform fmt recursive")

	map("n", "<leader>il", function()
		terraform.tflint()
	end, "Terraform lint")

	map("n", "<leader>it", function()
		terraform.trivy()
	end, "Terraform security scan")

	map("n", "<leader>iw", function()
		terraform.workspace_list()
	end, "Terraform workspaces")

	map("n", "<leader>iW", function()
		terraform.workspace_select()
	end, "Terraform select workspace")
end

return M
