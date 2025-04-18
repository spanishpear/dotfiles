return {
	"folke/persistence.nvim",
	event = "BufReadPre", -- this will only start session saving when an actual file was opened
	optional = true,
	opts = {
		-- add any custom options here
		pre_save = function()
			vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
		end,
	},
	keys = {
    -- stylua: ignore start
    { "<leader>ql", function() require("persistence").load() end, desc = "Load Session" },
    { "<leader>qs", function() require("persistence").select() end,desc = "Select Session" },
    { "<leader>qL", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    {
      "<leader>qS",
      function()
        local p = require("persistence")

        p.save()
        require("snacks").notify("Session Saved", { title = "Persistence" })
      end,
      desc = "Save Session",
    },
    {
      "<leader>qt",
      function()
        local isActive = true
        local p = require("persistence")
        if isActive then
          p.stop()
          isActive = false
          vim.notify("Stopped Session Recording", vim.log.levels.INFO, { title = "Persistence" })
        else
          p.start()
          isActive = true
          vim.notify("Started Session Recording", vim.log.levels.INFO, { title = "Persistence" })
        end
      end,
      desc = "Toggle Recording"
    }
,
	},
}
