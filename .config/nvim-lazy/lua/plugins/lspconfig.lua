local capabilities = vim.lsp.protocol.make_client_capabilities()

local servers = {
	bashls = {},
	clangd = {},
	pyright = {},
	rust_analyzer = {},
	eslint = {},
	lua_ls = {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			diagnostic = {
				globals = { "vim" },
			},
		},
	},
	eslint = {},
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
		config = function(_, opts)
			local lspconfig = require("lspconfig")

			-- iterate over the servers and setup each one
			for server, config in pairs(servers) do
				-- passing config.capabilities to blink.cmp merges with the capabilities in your
				-- `opts[server].capabilities, if you've defined it
				config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
				lspconfig[server].setup(config)
			end
		end,
	},
}
