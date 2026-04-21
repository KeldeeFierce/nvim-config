return {
	"neovim/nvim-lspconfig",
	opts = {
		setup = {
			rust_analyzer = function()
				return true
			end,
		},
	},

	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>DD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- sign_define is deprecated
		--
		-- local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		-- for type, icon in pairs(signs) do
		-- 	local hl = "DiagnosticSign" .. type
		-- 	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		-- end

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.INFO] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
				},
				linehl = {
					[vim.diagnostic.severity.ERROR] = "Error",
					[vim.diagnostic.severity.WARN] = "Warn",
					[vim.diagnostic.severity.INFO] = "Info",
					[vim.diagnostic.severity.HINT] = "Hint",
				},
			},
		})

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local capabilities = require("cmp_nvim_lsp").default_capabilities()

					vim.lsp.config(server_name, {
						capabilities = capabilities,
					})

					vim.lsp.enable(server_name)
				end,
				["jedi_language_server"] = function()
					-- configure bash language server
					lspconfig["jedi_language_server"].setup({
						capabilities = capabilities,
						filetypes = { "python" },
					})
				end,
			},
		})

		--		--
		-- mason_lspconfig.setup_handlers({
		-- 	-- default handler for installed servers
		-- 	function(server_name)
		-- 		lspconfig[server_name].setup({
		-- 			capabilities = capabilities,
		-- 		})
		-- 	end,
		-- 	["svelte"] = function()
		-- 		-- configure svelte server
		-- 		lspconfig["svelte"].setup({
		-- 			capabilities = capabilities,
		-- 			on_attach = function(client, bufnr)
		-- 				vim.api.nvim_create_autocmd("BufWritePost", {
		-- 					pattern = { "*.js", "*.ts" },
		-- 					callback = function(ctx)
		-- 						-- Here use ctx.match instead of ctx.file
		-- 						client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
		-- 					end,
		-- 				})
		-- 			end,
		-- 		})
		-- 	end,
		-- 	["graphql"] = function()
		-- 		-- configure graphql language server
		-- 		lspconfig["graphql"].setup({
		-- 			capabilities = capabilities,
		-- 			filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
		-- 		})
		-- 	end,
		-- 	["emmet_ls"] = function()
		-- 		-- configure emmet language server
		-- 		lspconfig["emmet_ls"].setup({
		-- 			capabilities = capabilities,
		-- 			filetypes = {
		-- 				"html",
		-- 				"typescriptreact",
		-- 				"javascriptreact",
		-- 				"css",
		-- 				"sass",
		-- 				"scss",
		-- 				"less",
		-- 				"svelte",
		-- 			},
		-- 		})
		-- 	end,
		-- 	["bashls"] = function()
		-- 		-- configure bash language server
		-- 		lspconfig["bashls"].setup({
		-- 			capabilities = capabilities,
		-- 			filetypes = { "sh" },
		-- 		})
		-- 	end,
		--
		-- 	["rust_analyzer"] = function()
		-- 		-- configure bash language server
		-- 		lspconfig["rust_analyzer"].setup({
		-- 			capabilities = capabilities,
		-- 			filetypes = { "rs" },
		-- 		})
		-- 	end,
		--
		-- 	["pyright"] = function()
		-- 		-- configure bash language server
		-- 		lspconfig["pyright"].setup({
		-- 			capabilities = capabilities,
		-- 			filetypes = { "python" },
		-- 		})
		-- 	end,
		--
		-- 	["ansiblels"] = function()
		-- 		-- configure bash language server
		-- 		lspconfig["ansiblels"].setup({
		-- 			capabilities = capabilities,
		-- 			settings = {
		-- 				ansible = {
		-- 					ansible = {
		-- 						path = "ansible",
		-- 					},
		-- 					ansibleLint = {
		-- 						enabled = true,
		-- 						path = "ansible-lint",
		-- 					},
		-- 					executionEnvironment = {
		-- 						enabled = false, -- Set to true if you use Ansible Execution Environments
		-- 					},
		-- 					python = {
		-- 						interpreterPath = "python3",
		-- 					},
		-- 					completion = {
		-- 						provideRedirectModules = true,
		-- 						provideModuleOptionAliases = true,
		-- 					},
		-- 				},
		-- 			},
		-- 			filetypes = { "yaml.ansible" },
		-- 		})
		-- 	end,
		-- 	-- ["basepyright"] = function()
		-- 	-- 	-- configure bash language server
		-- 	-- 	lspconfig["basedpyright"].setup({
		-- 	-- 		capabilities = capabilities,
		-- 	-- 		filetypes = { "python" },
		-- 	-- 	})
		-- 	-- end,
		-- 	--
		-- 	-- ["jedi_language_server"] = function()
		-- 	-- 	-- configure bash language server
		-- 	-- 	lspconfig["jedi_language_server"].setup({
		-- 	-- 		capabilities = capabilities,
		-- 	-- 		filetypes = { "python" },
		-- 	-- 	})
		-- 	-- end,
		--
		-- 	-- ["ruff-lsp"] = function()
		-- 	-- 	-- configure bash language server
		-- 	-- 	lspconfig["ruff-lsp"].setup({
		-- 	-- 		capabilities = capabilities,
		-- 	-- 		filetypes = { "python" },
		-- 	-- 	})
		-- 	-- end,
		-- 	["lua_ls"] = function()
		-- 		-- configure lua server (with special settings)
		-- 		lspconfig["lua_ls"].setup({
		-- 			capabilities = capabilities,
		-- 			settings = {
		-- 				Lua = {
		-- 					-- make the language server recognize "vim" global
		-- 					diagnostics = {
		-- 						globals = { "vim" },
		-- 					},
		-- 					completion = {
		-- 						callSnippet = "Replace",
		-- 					},
		-- 				},
		-- 			},
		-- 		})
		-- 	end,
		-- })
		--

		vim.lsp.config("lua_ls", {
			on_init = function(client)
				if client.workspace_folders then
					local path = client.workspace_folders[1].name
					if
						path ~= vim.fn.stdpath("config")
						and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
					then
						return
					end
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						-- Tell the language server which version of Lua you're using (most
						-- likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
						-- Tell the language server how to find Lua modules same way as Neovim
						-- (see `:h lua-module-load`)
						path = {
							"lua/?.lua",
							"lua/?/init.lua",
						},
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
							-- Depending on the usage, you might want to add additional paths
							-- here.
							-- '${3rd}/luv/library',
							-- '${3rd}/busted/library',
						},
						-- Or pull in all of 'runtimepath'.
						-- NOTE: this is a lot slower and will cause issues when working on
						-- your own configuration.
						-- See https://github.com/neovim/nvim-lspconfig/issues/3189
						-- library = vim.api.nvim_get_runtime_file('', true),
					},
				})
			end,
			settings = {
				Lua = {},
			},
		})

		vim.lsp.config("gopls", {
			capabilities = capabilities,
			settings = {
				gopls = {
					["ui.inlayhint.hints"] = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = false,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
			},
		})

		vim.lsp.enable("gopls")

		vim.lsp.config("pyright", {
			capabilities = capabilities,
		})
		vim.lsp.enable("pyright")

		vim.lsp.config("ruff", {
			on_attach = function(client)
				client.server_capabilities.hoverProvider = false
			end,
		})

		-- vim.lsp.config("ruff", {
		-- 	capabilities = capabilities,
		-- })
		-- vim.lsp.enable("ruff")

		vim.lsp.config("dockerls", {
			capabilities = capabilities,
		})
		vim.lsp.enable("dockerls")
	end,
}
