vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "playbooks/*.yml",
	command = "setfiletype yaml.ansible",
})
