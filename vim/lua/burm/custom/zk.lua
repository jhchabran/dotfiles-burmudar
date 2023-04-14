local api = require('zk.api')

local M = {}
M.new_journal = function()
  local home = vim.env.ZK_NOTEBOOK_DIR
  local opts = {
    group = "journal",
    template = "daily.md",
  }
  local noop = function()
  end

  api.new(home, opts, noop)
end

return M
