return {
	"pmizio/typescript-tools.nvim",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	opts = {
		settings = {
			-- some ridiculous settings
			tsserver_max_memory = 31215,
		},
	},
}
