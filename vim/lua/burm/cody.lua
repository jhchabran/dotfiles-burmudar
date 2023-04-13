vim.api.nvim_create_user_command("CodyR", function(command)
  local p = "file://" .. vim.fn.expand('%:p')

  vim.lsp.buf.execute_command({
    command = "cody",
    arguments = { p, command.line1 - 1, command.line2 - 1, command.args, true, true }
  })
end, { range = 2, nargs = 1 })


vim.api.nvim_create_user_command("CodyA", function(command)
  local p = "file://" .. vim.fn.expand('%:p')

  vim.lsp.buf.execute_command({
    command = "cody",
    arguments = { p, command.line1 - 1, command.line2 - 1, command.args, false, false }
  })
end, { range = 2, nargs = 1 })

vim.api.nvim_create_user_command("CodyC", function(command)
  local p = "file://" .. vim.fn.expand('%:p')

  vim.lsp.buf.execute_command({
    command = "cody",
    arguments = { p, command.line1 - 1, command.line2 - 1, command.args, false, true }
  })
end, { range = 2, nargs = 1 })
