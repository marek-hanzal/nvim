vim.api.nvim_create_user_command("BufferPrune", function()
	require("util.buffer_prune").prune()
end, {
	desc = "Delete hidden least-recently-used buffers past the configured limit",
})
