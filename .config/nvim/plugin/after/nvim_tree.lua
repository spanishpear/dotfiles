require'nvim-tree'.setup {
  view = {
    mappings = {
      custom_only = false,
      list = {
          { key = "<C-e>", action = "" },
      }
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
  }
}


vim.keymap.set("n", "<C-e>", function ()
  require('nvim-tree').toggle(nil, nil, nil, nil)
end)

vim.keymap.set("n", "<leader>r", '<Cmd>NvimTreeRefresh<CR>' )
vim.keymap.set("n", "<leader>n", '<Cmd>NvimTreeFindFile<CR>' )

--  a list of groups can be found at `:help nvim_tree_highlight`
-- highlight NvimTreeFolderIcon guibg=blue

