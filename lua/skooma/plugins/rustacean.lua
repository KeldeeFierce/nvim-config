return {
	"mrcjkb/rustaceanvim",
	version = "^6", -- Recommended
	lazy = false, -- This plugin is already lazy
	config = function()
		vim.g.rustaceanvim = {
			dap = {
				configuration = false, -- Disable custom DAP configuration
			},
		}
	end,
}
