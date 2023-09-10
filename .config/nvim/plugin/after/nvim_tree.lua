local function my_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true}
  end
  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.del('n', '<C-e>', { buffer = bufnr })

  vim.keymap.set('n', '?', api.tree.toggle_help, opts("toggle help"))

end

require('nvim-tree').setup {
  on_attach = my_on_attach,
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

vim.keymap.set("n", "<leader>r", '<Cmd>NvimTreeRefresh<CR>' )
vim.keymap.set("n", "<leader>n", '<Cmd>NvimTreeFindFile<CR>' )
vim.keymap.set("n", "<C-e>", '<Cmd>NvimTreeToggle<CR>' )


