local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.del('n', '<C-e>', { buffer = bufnr })
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
end

require'nvim-tree'.setup {
  on_attach = my_on_attach,
  view = {
    mappings = {
      custom_only = false,
    },
  },
  renderer = {
    indent_markers = {
      enable = true,
    },
    icons = {
      glyphs = {
        default = '',
        folder =  {
          arrow_closed = "",
          arrow_open = "",
        },
      },
    }
  },
  respect_buf_cwd = true,
  sync_root_with_cwd = false,
  update_focused_file = {
    enable = true,
  },
}

vim.keymap.set("n", "<C-e>", function ()
  require('nvim-tree.api').tree.toggle()
end)


vim.keymap.set("n", "<leader>r", '<Cmd>NvimTreeRefresh<CR>' )
vim.keymap.set("n", "<leader>n", '<Cmd>NvimTreeFindFile<CR>' )

--  a list of groups can be found at `:help nvim_tree_highlight`
-- highlight NvimTreeFolderIcon guibg=blue

