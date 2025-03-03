require("conform").setup({
  -- Enable logging - then use :ConformInfo
  -- log_level = vim.log.levels.DEBUG,
  formatters_by_ft = {

    lua = { "stylua" },

    python = { "isort", "black" },

    rust = { "rustfmt", lsp_format = "fallback" },
    
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },

    -- shell
    bash = { "shfmt", "shellharden", "shellcheck"},
    sh = { "shfmt", "shellharden", "shellcheck"},
  },

  -- Disable with a global or buffer-local variable
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 500, lsp_format = "fallback" }
  end,

  -- per-language configuration
  formatters = {
    -- Adds environment args to the prettierd formatter
    prettierd = {
      env = {
        PRETTIERD_LOCAL_PRETTIER_ONLY=1,
        PRETTIERD_DEFAULT_CONFIG="$HOME/atlassian/afm/jira/.prettierrc"
      },
    },
  }
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

-- create :FormatDisable command to disable autoformat-on-save
vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})

-- create :FormatEnable command to re-enable autoformat-on-save
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})
