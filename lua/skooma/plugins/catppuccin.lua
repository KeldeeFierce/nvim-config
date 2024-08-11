-- return { "catppuccin/nvim", name = "catppuccin", priority = 1000 }

return {
	"catppuccin/nvim",
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		-- load the colorscheme here
		require("catppuccin").setup({
			flavour = "macchiato",
			transparent_background = true,
			no_italic = true,
		})
		vim.cmd("colorscheme catppuccin")

		local function changebg_opaque()
			require("catppuccin").setup({
				flavour = "macchiato",
				transparent_background = false,
				no_italic = true,
			})

			vim.cmd("colorscheme catppuccin")
		end

		local function changebg_transperent()
			require("catppuccin").setup({
				flavour = "macchiato",
				transparent_background = true,
				no_italic = true,
			})

			vim.cmd("colorscheme catppuccin")
		end

		vim.keymap.set("n", "<leader>qo", changebg_opaque)
		vim.keymap.set("n", "<leader>qt", changebg_transperent)
	end,
}
