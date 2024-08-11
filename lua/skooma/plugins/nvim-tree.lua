return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		local nvimtree = require("nvim-tree")

		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- vim.g.nvim_tree_icons = {
		-- default = '',
		-- }
		nvimtree.setup({
			view = {
				width = 45,
				relativenumber = true,
			},
			-- change folder arrow icons
			renderer = {
				indent_markers = {
					enable = true,
				},
				--   icons = {
				--     glyphs = {
				--       folder = {
				--         arrow_closed = "", -- arrow when folder is closed
				--         arrow_open = "", -- arrow when folder is open
				--       },
				--     },
				--   },
			},
			-- disable window_picker for
			-- explorer to work well with
			-- window splits
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			filters = {
				custom = { ".DS_Store" },
			},
			git = {
				ignore = false,
			},
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
		keymap.set(
			"n",
			"<leader>ef",
			"<cmd>NvimTreeFindFileToggle<CR>",
			{ desc = "Toggle file explorer on current file" }
		) -- toggle file explorer on current file
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer

		-- autoclose, no idea how it works
		local function is_modified_buffer_open(buffers)
			for _, v in pairs(buffers) do
				if v.name:match("NvimTree_") == nil then
					return true
				end
			end
			return false
		end

		vim.api.nvim_create_autocmd("BufEnter", {
			nested = true,
			callback = function()
				if
					#vim.api.nvim_list_wins() == 1
					and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil
					and is_modified_buffer_open(vim.fn.getbufinfo({ bufmodified = 1 })) == false
				then
					vim.cmd("quit")
				end
			end,
		})
	end,
}
