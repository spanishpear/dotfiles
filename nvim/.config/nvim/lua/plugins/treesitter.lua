return {
	"nvim-treesitter/nvim-treesitter",
	-- don't even load it
	-- https://github.com/LazyVim/LazyVim/discussions/1583
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
	build = function()
		require("nvim-treesitter.install").update({ with_sync = true })()
	end,
	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "rust", "typescript", "help", "tsx" },
			ignore_install = { "help" },
			sync_install = false,
			highlight = {
				enable = true,
				disable = function(lang, buf)
					local max_filesize = 200 * 1024 -- 200 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
			},
			indent = { enable = true },
		})
	end,
}
