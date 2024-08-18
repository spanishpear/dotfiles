-- setup neodev before LSP
require("neodev").setup({})

local function get_bufnr(bufnr)
    return type(bufnr) == 'number' and bufnr or vim.api.nvim_get_current_buf()
end

local function root_dir_from_pattern(bufnr, pattern)
    local root_dir = vim.fs.root(get_bufnr(bufnr), pattern)
    return root_dir or vim.loop.cwd()
end

local function yarn_lock_root_dir(bufnr)
    return root_dir_from_pattern(bufnr, 'yarn.lock')
end

-- Pass in `typescript-tools` config



-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- log when it's attached_bufs
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  bashls = {},
  clangd = {},
  pyright = {},
  rust_analyzer = {},
  -- not used - using https://github.com/pmizio/typescript-tools.nvim
  -- tsserver = {
  --     init_options = {
  --       hostInfo = "neovim",
  --       maxTsServerMemory = 18432,
  --       tsserver = {
  --         -- logVerbosity [string] Verbosity of the information logged into the tsserver log files. Log levels from least to most amount of details: 'off', 'terse', 'normal', 'requestTime', 'verbose'. Default: 'off'
  --         logVerbosity = "verbose",
  --         logDirectory = "/Users/ssomaiya/.lsplog/tsserver",
  --         path = "/Users/ssomaiya/atlassian/afm/jira/node_modules/typescript/lib/tsserver.js",
  --         root_dir = function(...)
  --           return require("lspconfig.util").root_pattern("yarn.lock")(...)
  --         end,
  --
  --     }
  --   },
  -- },
  eslint = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostic = {
        globals = {"vim"}
      },
        format = {
          enable = true,
          -- Put format options here
          -- NOTE: the value should be STRING!!
          defaultConfig = {
            indent_style = "space",
            indent_size = "2",
          }
        },
    },
  },
}


require("typescript-tools").setup {
  on_attach = on_attach,
  handlers = {
    ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded',
    }),
  },
  root_dir = function(_, bufnr)
      return yarn_lock_root_dir(bufnr)
  end,
  settings = {
    expose_as_code_action = 'all',
    publish_diagnostic_on = 'change',
    tsserver_max_memory = 18432,
    tsserver_file_preferences = {
        includeCompletionsForModuleExports = true,
        includeInlayParameterNameHints = 'all',
    },
    jsx_close_tag = {
        enable = true,
        filetypes = { 'typescriptreact' },
    }
  }
}


-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Option 2: nvim lsp as LSP client
-- Tell the server the capability of foldingRange,
-- Neovim hasn't added foldingRange to default capabilities, users must add it manually
local fold_capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
local language_servers = require("lspconfig").util.available_servers() -- or list servers manually like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
    require('lspconfig')[ls].setup({
        capabilities = fold_capabilities,
        on_attach = on_attach,
        settings = servers[ls]
        -- you can add other fields for setting up lsp server in this table
    })
end
require('ufo').setup()

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

-- mason_lspconfig.setup_handlers {
--   function(server_name)
--     require('lspconfig')[server_name].setup {
--       capabilities = capabilities,
--       on_attach = on_attach,
--       settings = servers[server_name],
--     }
--   end,
-- }
--
require'lspconfig'.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
          },
          diagnostics = {
            globals = { "vim" },
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            }
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          }
        }
      })

      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
    return true
  end,
}


require 'lspconfig'.eslint.setup({
   settings = {
     packageManager = 'yarn'
   },
   on_attach = function(client, bufnr)
     vim.api.nvim_create_autocmd("BufWritePre", {
       buffer = bufnr,
       command = "EslintFixAll",
     })
   end,
})

