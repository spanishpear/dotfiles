vim.b.snacks_animate = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true
vim.opt.relativenumber = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- don't keep highlight on search
vim.o.hlsearch = false

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Set colorscheme

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- enable virtual text
vim.diagnostic.config({
	virtual_text = true,
})

-- set github copilot settings
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.keymap.set(
	"i",
	"<C-y>",
	"copilot#Accept('<CR>')",
	{ noremap = true, silent = true, expr = true, replace_keycodes = false }
)

-- set relative number
vim.wo.relativenumber = true
vim.g.rooter_patterns = { ">afm", ">atlassian-frontend-monorepo" }
vim.g.prosession_per_branch = 1

-- some fixed colors
vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#928374" })
vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { fg = "#928374" })
