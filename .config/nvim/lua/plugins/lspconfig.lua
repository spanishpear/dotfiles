local servers = {
	bashls = {},
	clangd = {},
	pyright = {},
	rust_analyzer = {},
	eslint = {},
	lua_ls = {
		on_init = function(client)
			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if
					path ~= vim.fn.stdpath("config")
					and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
				then
					return
				end
			end

			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = {
					-- Tell the language server which version of Lua you're using
					-- (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
				},
				-- Make the server aware of Neovim runtime files
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
						-- Depending on the usage, you might want to add additional paths here.
						"${3rd}/luv/library",
						-- "${3rd}/busted/library",
					},
					-- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
					-- library = vim.api.nvim_get_runtime_file("", true)
				},
			})
		end,
		settings = {
			Lua = {
				workspace = {
					checkThirdParty = false,
				},
				codeLens = {
					enable = true,
				},
				completion = {
					callSnippet = "Replace",
				},
				doc = {
					privateName = { "^_" },
				},
				hint = {
					enable = true,
					setType = false,
					paramType = true,
					paramName = "Disable",
					semicolon = "Disable",
					arrayIndex = "Disable",
				},
			},
		},
	},
}

return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
				ensure_installed = {
					"stylua",
					"shfmt",
					"shellharden",
					"lua_ls",
					"bashls",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			automatic_installation = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		dependencies = { "saghen/blink.cmp" },

		-- On Neovim 0.11+ and Blink.cmp 0.10+ with vim.lsp.config, you may skip this step. This is still required when using nvim-lspconfig until this issue is completed
		-- https://github.com/neovim/nvim-lspconfig/issues/3494
		config = function(_, _)
			local lspconfig = require("lspconfig")

			-- iterate over the servers and setup each one
			for server, config in pairs(servers) do
				-- passing config.capabilities to blink.cmp merges with the capabilities in your
				-- `opts[server].capabilities, if you've defined it
				-- note - get_lsp_capabilities by default will call lsp make_client_capabilities
				local capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				-- setup capabilities for nvim-ufo
				capabilities.textDocument.foldingRange = {
					dynamicRegistration = false,
					rangeLimit = 5000,
					lineFoldingOnly = true,
				}
				config.capabilities = capabilities
				lspconfig[server].setup(config)
			end
		end,
	},
}
