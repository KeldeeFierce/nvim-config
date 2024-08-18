vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap

keymap.set("n", "<leader>k", ":nohl<CR>")
keymap.set("n", "<leader>q", ":bd<CR>")
keymap.set("n", "<C-k>", ":bnext<CR>")
keymap.set("n", "<C-j>", ":bprev<CR>")
