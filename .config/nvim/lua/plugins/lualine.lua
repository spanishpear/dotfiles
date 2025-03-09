return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		icons_enabled = true,
		theme = "gruvbox",
		component_separators = "|",
		section_separators = "",
		sections = {
			lualine_x = {
				{
					require("lazy.status").updates,

					cond = require("lazy.status").has_updates,
					color = { fg = "#ff9e64" },
				},
			},
		},
	},
}
