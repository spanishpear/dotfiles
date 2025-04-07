-- [[ Setting options ]]
-- See `:help vim.o`
vim.cmd("au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm,*.tera set ft=jinja")
-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

vim.opt.relativenumber = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true
vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme gruvbox]])

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank { timeout = 200 }
  end,
  group = highlight_group,
  pattern = '*',
})

vim.diagnostic.config({
  virtual_text = true
})

-- set github copilot settings
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.keymap.set('i', '<C-y>', "copilot#Accept('<CR>')", {noremap = true, silent = true, expr=true, replace_keycodes = false })


-- copilot accept 

vim.keymap.set('n', '<A-t>', ':FloatermToggle<CR>i', {noremap = true})
vim.keymap.set('!', '<A-t>', '<Esc>:FloatermToggle<CR>i', {noremap = true})
vim.keymap.set('t', '<A-t>', '<C-\\><C-n>:FloatermToggle<CR>', {noremap = true})

-- set relative number
vim.wo.relativenumber = true

vim.g.rooter_patterns = {'>afm'}

vim.g.prosession_per_branch = 1
vim.g.floaterm_keymap_toggle = '<A-t>'

-- vim.g["prettier#autoformat"] = 1
-- vim.g["prettier#autoformat_require_pragma"] = 0
