return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",

	config = function()
		require("bufferline").setup({
			options = {
				separator_style = "slant",
				always_show_bufferline = false,
			},
			highlights = {
				buffer_selected = {
					italic = false,
				},
				buffer_visible = {
					italic = false,
				},
				tab_selected = {
					italic = false,
				},
			},
		})
	end,
}
