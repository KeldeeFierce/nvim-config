return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"mfussenegger/nvim-dap-python",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")

			require("mason-nvim-dap").setup({
				-- Makes a best effort to setup the various debuggers with
				-- reasonable debug configurations
				automatic_installation = true,

				-- You can provide additional configuration to the handlers,
				-- see mason-nvim-dap README for more information
				handlers = {},

				-- You'll need to check that you have the required things installed
				-- online, please don't ask me how to install them :)
				ensure_installed = {
					-- Update this to ensure that you have the debuggers for the langs you want
					"cpptools",
				},
			})

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

			local user = os.getenv("USER")
			-- local py_db_path = "/home/skooma/.local/share/nvim/mason/packages/debugpy/venv/bin/python3"
			local py_db_path = "/home/" .. user .. "/.local/share/nvim/mason/packages/debugpy/venv/bin/python3"

			-- require("dap-python").setup("python3") --Use local debugger
			require("dap-python").setup(py_db_path) --Use Mason debugger
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

			--CODELLDB

			dap.configurations.rust = {
				{
					name = "Launch",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input(
							"Path to executable: ",
							vim.fn.getcwd() .. "/target/debug/" .. (vim.fn.fnamemodify(vim.fn.getcwd(), ":t")),
							"file"
						)
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
					-- args = {},
					args = function()
						local input = vim.fn.input("Program arguments: ")
						return vim.split(input, " ")
					end,
					-- ... the previous config goes here ...,
					initCommands = function()
						-- Find out where to look for the pretty printer Python module
						local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

						local script_import = 'command script import "'
							.. rustc_sysroot
							.. '/lib/rustlib/etc/lldb_lookup.py"'
						local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

						local commands = {}
						local file = io.open(commands_file, "r")
						if file then
							for line in file:lines() do
								table.insert(commands, line)
							end
							file:close()
						end
						table.insert(commands, 1, script_import)

						return commands
					end,
					-- ...,
				},
			}

			--LLDB
			-- dap.adapters.lldb = {
			-- 	type = "executable",
			-- 	command = "/usr/bin/lldb", -- adjust as needed, must be absolute path
			-- 	name = "lldb",
			-- }
			--
			-- dap.configurations.rust = {
			-- 	{
			-- 		name = "Launch",
			-- 		type = "lldb",
			-- 		request = "launch",
			-- 		program = function()
			-- 			return vim.fn.input(
			-- 				"Path to executable: ",
			-- 				vim.fn.getcwd() .. "/target/debug/" .. (vim.fn.fnamemodify(vim.fn.getcwd(), ":t")),
			-- 				"file"
			-- 			)
			-- 		end,
			-- 		cwd = "${workspaceFolder}",
			-- 		stopOnEntry = false,
			-- 		args = {},
			-- 		-- ... the previous config goes here ...,
			-- 		initCommands = function()
			-- 			-- Find out where to look for the pretty printer Python module
			-- 			local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))
			--
			-- 			local script_import = 'command script import "'
			-- 				.. rustc_sysroot
			-- 				.. '/lib/rustlib/etc/lldb_lookup.py"'
			-- 			local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"
			--
			-- 			local commands = {}
			-- 			local file = io.open(commands_file, "r")
			-- 			if file then
			-- 				for line in file:lines() do
			-- 					table.insert(commands, line)
			-- 				end
			-- 				file:close()
			-- 			end
			-- 			table.insert(commands, 1, script_import)
			--
			-- 			return commands
			-- 		end,
			-- 		-- ...,
			-- 	},
			-- }
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

			vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "dap-float",
				callback = function()
					vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>close!<CR>", { noremap = true, silent = true })
				end,
			})
		end,
	},
	{
		"leoluz/nvim-dap-go",
		config = function()
			require("dap-go").setup({
				dap_configurations = {
					{
						-- Must be "go" or it will be ignored by the plugin
						type = "go",
						name = "Attach remote",
						mode = "remote",
						request = "attach",

						args = function()
							local input = vim.fn.input("Program arguments: ")
							return vim.split(input, " ")
						end,
					},
				},
				delve = {
					-- the path to the executable dlv which will be used for debugging.
					-- by default, this is the "dlv" executable on your PATH.
					path = "dlv",
					-- time to wait for delve to initialize the debug session.
					-- default to 20 seconds
					initialize_timeout_sec = 20,
					-- a string that defines the port to start delve debugger.
					-- default to string "${port}" which instructs nvim-dap
					-- to start the process in a random available port.
					-- if you set a port in your debug configuration, its value will be
					-- assigned dynamically.
					port = "${port}",
					-- additional args to pass to dlv
					args = {},
					-- the build flags that are passed to delve.
					-- defaults to empty string, but can be used to provide flags
					-- such as "-tags=unit" to make sure the test suite is
					-- compiled during debugging, for example.
					-- passing build flags using args is ineffective, as those are
					-- ignored by delve in dap mode.
					-- avaliable ui interactive function to prompt for arguments get_arguments
					build_flags = {},
					-- whether the dlv process to be created detached or not. there is
					-- an issue on delve versions < 1.24.0 for Windows where this needs to be
					-- set to false, otherwise the dlv server creation will fail.
					-- avaliable ui interactive function to prompt for build flags: get_build_flags
					detached = vim.fn.has("win32") == 0,
					-- the current working directory to run dlv from, if other than
					-- the current working directory.
					cwd = nil,
				},
				tests = {
					-- enables verbosity when running the test.
					verbose = false,
				},
			})
		end,
	},
}
