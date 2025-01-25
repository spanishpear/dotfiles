-- Create a custom lua script that can be mapped to a keybinding
-- that copies the link to the current line in the current file.
-- For example, the filepath src/packages/admin-pages/common/src/index.tsx line 10 can be found at the link 
-- https://stash.atlassian.com/projects/ATLASSIAN/repos/atlassian-frontend-monorepo/browse/jira/src/packages/admin-pages/common/src/index.tsx#10
-- TODO: move me to https://github.com/linrongbin16/gitlinker.nvim or https://github.com/tommcdo/vim-fubitive (or both)

function BitbucketLink()
  local file_path = vim.fn.expand('%:p')
  -- make sure we strip every text that is not AFTER afm
  -- make sure it works for variants like `afm-sparse/` or `afm-full` or `afm/`
  file_path = string.match(file_path, "afm.*/(.*)")


  local line_number = vim.fn.line('.')
  local repo_url = "https://stash.atlassian.com/projects/ATLASSIAN/repos/atlassian-frontend-monorepo/browse/"
  local link = repo_url .. file_path .. "#" .. line_number
  vim.fn.setreg("+", link)
  print("Copied to clipboard: " .. link)
end

-- map the function to a keybinding
vim.api.nvim_set_keymap('n', '<leader>bl', ':lua BitbucketLink()<CR>', { noremap = true, silent = true })
