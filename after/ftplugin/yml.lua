vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "playbooks/*.yml",
	command = "setfiletype yaml.ansible",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "group_vars/*.yml",
	command = "setfiletype yaml.ansible",
})
