local telescope = require('telescope')
local builtin = require('telescope.builtin')

local custom_telescope_command = {}

custom_telescope_command.find_ssomaiya_files = function(opts)
  opts = opts or {}
  opts.search = 'ssomaiya'

  -- First, search for 'ssomaiya' using live_grep
  builtin.live_grep(opts, function()
    -- Collect the file paths from the live_grep results
    local file_paths = {}
    for _, entry in ipairs(action_state.get_selected_entry()) do
      table.insert(file_paths, entry.path)
    end

    -- Pass the collected file paths to find_files
    opts.cwd = vim.loop.cwd()
    opts.paths = file_paths
    builtin.find_files(opts)
  end)
end

return custom_telescope_command

