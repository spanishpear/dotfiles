return {
	"folke/trouble.nvim",
	optional = true,
	specs = {
		"folke/snacks.nvim",
		opts = function(_, opts)
			return vim.tbl_deep_extend("force", opts or {}, {
				use_lsp_diagnostic_signs = true,
				picker = {
					actions = require("trouble.sources.snacks").actions,
					win = {
						input = {

							keys = {
								["<c-t>"] = {
									"trouble_open",
									mode = { "n", "i" },
								},
							},
						},
					},
				},
			})
		end,
	},
}
