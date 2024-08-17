return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"mfussenegger/nvim-dap-python",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		require("dap-python").setup("python3")
		require("dapui").setup()
		--To install manually:
		-- dap.adapters.python = function(cb, config)
		-- 	if config.request == "attach" then
		-- 		---@diagnostic disable-next-line: undefined-field
		-- 		local port = (config.connect or config).port
		-- 		---@diagnostic disable-next-line: undefined-field
		-- 		local host = (config.connect or config).host or "127.0.0.1"
		-- 		cb({
		-- 			type = "server",
		-- 			port = assert(port, "`connect.port` is required for a python `attach` configuration"),
		-- 			host = host,
		-- 			options = {
		-- 				source_filetype = "python",
		-- 			},
		-- 		})
		-- 	else
		-- 		cb({
		-- 			type = "executable",
		-- 			command = "path/to/virtualenvs/debugpy/bin/python",
		-- 			args = { "-m", "debugpy.adapter" },
		-- 			options = {
		-- 				source_filetype = "python",
		-- 			},
		-- 		})
		-- 	end
		-- end
		--
		vim.keymap.set("n", "<F5>", function()
			require("dap").continue()
		end)
		vim.keymap.set("n", "<F10>", function()
			require("dap").step_over()
		end)
		vim.keymap.set("n", "<F11>", function()
			require("dap").step_into()
		end)
		vim.keymap.set("n", "<F12>", function()
			require("dap").step_out()
		end)
		vim.keymap.set("n", "<Leader>b", function()
			require("dap").toggle_breakpoint()
		end)
		vim.keymap.set("n", "<Leader>B", function()
			require("dap").set_breakpoint()
		end)
		vim.keymap.set("n", "<Leader>lp", function()
			require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
		end)
		vim.keymap.set("n", "<Leader>dr", function()
			require("dap").repl.open()
		end)
		vim.keymap.set("n", "<Leader>dl", function()
			require("dap").run_last()
		end)
		vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
			require("dap.ui.widgets").hover()
		end)
		vim.keymap.set({ "n", "v" }, "<Leader>dp", function()
			require("dap.ui.widgets").preview()
		end)
		vim.keymap.set("n", "<Leader>df", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.frames)
		end)
		vim.keymap.set("n", "<Leader>ds", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.scopes)
		end)
	end,
}