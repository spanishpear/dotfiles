local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")
	local function copy_node_path()
		local node = api.tree.get_node_under_cursor()
		-- copy node relative path from root directory to clipboard
		local absolute_path = node.absolute_path
		local file_path = string.match(absolute_path, "afm/(.*)")
		vim.fn.setreg("+", file_path)
		vim.notify("Copied path to clipboard: " .. file_path)
	end

	-- use `opts("some description")` to add a description to the keymap
	-- e.g. `vim.keymap.set("n", "q", "<Cmd>quit<CR>", opts("quit"))`
	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- add default mappings
	api.config.mappings.default_on_attach(bufnr)
	-- override with below to toggle on C-e
	vim.keymap.del("n", "<C-E>", { buffer = bufnr })
	vim.keymap.set("n", "<C-P>", copy_node_path, opts("Print Path"))
end

require("nvim-tree").setup({
	on_attach = my_on_attach,
	renderer = {
		indent_markers = {
			enable = true,
		},
		icons = {
			glyphs = {
				default = "",
				folder = {
					arrow_closed = "",
					arrow_open = "",
				},
			},
		},
	},
	respect_buf_cwd = true,
	sync_root_with_cwd = false,
	update_focused_file = {
		enable = true,
	},
	git = {
		timeout = 500,
	},
	filesystem_watchers = {
		enable = true,
		debounce_delay = 50,
		ignore_dirs = {
			"node_modules",
			"tsDist",
			"build",
			"dist",
		},
	},
})

vim.keymap.set("n", "<leader>r", "<Cmd>NvimTreeRefresh<CR>")
vim.keymap.set("n", "<leader>n", "<Cmd>NvimTreeFindFile<CR>")
vim.keymap.set("n", "<C-e>", "<Cmd>NvimTreeToggle<CR>")
