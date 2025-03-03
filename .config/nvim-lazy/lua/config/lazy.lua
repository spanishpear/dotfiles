-- ================= Pre-req =================
-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ================= Bootstrap =================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },

			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

-- ================= Init =================
require("lazy").setup({
	spec = {
		{ import = "plugins" },
		-- auto setup from `lua/config/plugins/*.lua`
		{
			"morhetz/gruvbox",
			lazy = false,
			config = function()
				-- ensure colorscheme relevant options set correctly
				vim.o.termguicolors = true
				-- or "light" for light mode
				vim.o.background = "dark"
				-- gruvbox doesn't load the colorscheme by default
				vim.cmd.colorscheme("gruvbox")
			end,
		},
	},

	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "gruvbox" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
