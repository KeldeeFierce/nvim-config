vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap

keymap.set("n", "<leader>k", ":nohl<CR>")
keymap.set("n", "<leader>q", ":bd<CR>")
keymap.set("n", "<C-k>", ":bnext<CR>")
keymap.set("n", "<C-j>", ":bprev<CR>")

vim.opt.langmap = {
	"ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz",
}

vim.keymap.set("n", "<leader>hh", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end)
