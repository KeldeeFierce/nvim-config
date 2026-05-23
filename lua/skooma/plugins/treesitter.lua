return {
	"nvim-treesitter/nvim-treesitter",
	-- event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter")

		-- configure treesitter
		treesitter.setup({
			install_dir = vim.fn.stdpath("data") .. "/site",

			-- -- enable syntax highlighting
			-- highlight = {
			-- 	enable = true,
			-- 	disable = { "dockerfile" },
			-- },
			-- -- enable indentation
			-- indent = { enable = true, disable = { "python" } },
			-- -- enable autotagging (w/ nvim-ts-autotag plugin)
			-- autotag = {
			-- 	enable = true,
			-- },
			-- -- ensure these language parsers are installed
			-- incremental_selection = {
			-- 	enable = true,
			-- 	keymaps = {
			-- 		init_selection = "<C-space>",
			-- 		node_incremental = "<C-space>",
			-- 		scope_incremental = false,
			-- 		node_decremental = "<bs>",
			-- 	},
			-- },
		})

		treesitter.install({
			"json",
			"javascript",
			"typescript",
			"tsx",
			"yaml",
			"html",
			"css",
			"prisma",
			"markdown",
			"markdown_inline",
			"svelte",
			"graphql",
			"bash",
			"lua",
			"vim",
			"dockerfile",
			"gitignore",
			"query",
			"vimdoc",
			"c",
			"python",
			"go",
			"rust",
			"sql",
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
			end,
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "python",
			callback = function()
				vim.bo.indentexpr = ""
			end,
		})

		--Disable some filetypes, shoud try it later
		--
		-- vim.api.nvim_create_autocmd("FileType", {
		-- 	callback = function(args)
		-- 		local ft = vim.bo[args.buf].filetype
		--
		-- 		local disabled = {
		-- 			dockerfile = true,
		-- 		}
		--
		-- 		if disabled[ft] then
		-- 			return
		-- 		end
		--
		-- 		pcall(vim.treesitter.start, args.buf)
		-- 	end,
		-- })
	end,
}
