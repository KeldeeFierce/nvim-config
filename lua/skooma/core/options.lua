vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

vim.opt.guicursor = ""
-- tabs & indent
opt.tabstop = 4 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 4 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- search settings
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

-- colors
opt.termguicolors = true
opt.background = "dark"
-- opt.signcolumn = "yes"

opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

opt.signcolumn = "yes"

vim.api.nvim_create_autocmd("FileType", {
	pattern = "dap-float",
	callback = function()
		vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<CR>", { noremap = true, silent = true })
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "playbooks/*.{yml,yaml}",
	command = "setfiletype yaml.ansible",
})

vim.lsp.inlay_hint.enable(true)

-- for inline diagnostics
-- vim.diagnostic.config({ virtual_lines = true })
-- vim.diagnostic.config({ virtual_text = true })

vim.diagnostic.config({
	virtual_text = {
		spacing = 2,
		prefix = "■",
		-- severity = { min = vim.diagnostic.severity.HINT },
	},
})

vim.filetype.add({
	filename = {
		["docker-compose.yml"] = "yaml.docker-compose",
		["docker-compose.yaml"] = "yaml.docker-compose",
		["compose.yml"] = "yaml.docker-compose",
		["compose.yaml"] = "yaml.docker-compose",
		[".env"] = "dotenv",
	},
})
