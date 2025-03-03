-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {desc = "Next diagnostic"})
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {desc = "Previous diagnostic"})
vim.keymap.set('n', '<leader>do', vim.diagnostic.open_float, { desc = '[D]iagnostic AAAAAAA [O]pen' })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = '[D]iagnostic [Q]uickfix' })
-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  -- Syntax aware objects
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
        local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
        ts_update()
    end,
    requires = {
      { "nvim-telescope/telescope-live-grep-args.nvim" },
    },
    config = function()
      require("telescope").load_extension("live_grep_args")
    end,
  }


  -- LSP Configuration & Plugins
  use {
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      -- provides completion services for nvim configs
      'folke/neodev.nvim',
    },
  }
  
  -- use "folke/snacks.nvim"

  -- github copilot 
  use 'github/copilot.vim'

  use 'mechatroner/rainbow_csv'

  use 'airblade/vim-rooter'

  -- Autocompletion
  use {
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  }

  -- while tree-sitter doesn't work for typescript
  use {
    "pmizio/typescript-tools.nvim",
    requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  }


  -- surround bindings
  use 'tpope/vim-surround'

  -- keep state between sessions
  use {
    'dhruvasagar/vim-prosession',
    requires = {'tpope/vim-obsession'}
  }

  -- shows keybindings for the next key in a chord
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {}
    end
  }

  -- zen mode
  use {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup {
      }
    end
  }

  -- selective highlighting, e.g. for zen
  use {
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup {
      }
    end
  }


  -- GIT RELATED --
  use 'tpope/vim-fugitive' -- :Git commands
  use 'tpope/vim-rhubarb' -- enables :GBrowse
  use 'lewis6991/gitsigns.nvim' -- gutter decorations for git

  -- theming --
  use 'dracula/vim' 
  use 'ellisonleao/gruvbox.nvim' 
  use 'folke/tokyonight.nvim' 
  use { "catppuccin/nvim", as = "catppuccin" }
  -- toggle themes via :Themery
  use 'zaldih/themery.nvim'


  -- STYLING--
  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically
  use {'romgrk/barbar.nvim', requires = 'nvim-web-devicons'} -- tabs

  -- for file explorer
  use 'nvim-tree/nvim-web-devicons'
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- for file icons
    },
  }

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  }
  use {
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  }

  -- jinja highlights
  use 'lepture/vim-jinja'

  -- allow for better jumping 
  use {
    'easymotion/vim-easymotion',
  }

  -- LSP loading state
  use {
    'j-hui/fidget.nvim',
    config = function()
      require("fidget").setup {}
    end,
  }

  -- vim hard time, makes my life harder
  use {
    'm4xshen/hardtime.nvim',
    requires = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("hardtime").setup()
    end,
  }

  -- formatting
  use({
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup()
    end,
  })


  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

require('Comment').setup()
