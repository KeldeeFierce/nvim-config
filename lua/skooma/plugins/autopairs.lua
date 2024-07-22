return {
	"windwp/nvim-autopairs",

	config = function()
		local autopairs = require("nvim-autopairs")
		autopairs.setup({
			-- put this to setup function and press <a-e> to use fast_wrap
			fast_wrap = {},
		})
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	end,
}
