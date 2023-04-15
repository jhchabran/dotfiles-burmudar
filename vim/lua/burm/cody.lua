local function register_commands()
  vim.api.nvim_create_user_command("CodyR", function(command)
    local p = "file://" .. vim.fn.expand('%:p')

    for _, client in pairs(vim.lsp.get_active_clients({ name = "llmsp" })) do
      client.request("workspace/executeCommand", {
        command = "cody",
        arguments = { p, command.line1 - 1, command.line2 - 1, command.args, true, true }
      }, function()
      end, 0)
    end
  end, { range = 2, nargs = 1 })

  vim.api.nvim_create_user_command("CodyC", function(command)
    local p = "file://" .. vim.fn.expand('%:p')

    for _, client in pairs(vim.lsp.get_active_clients({ name = "llmsp" })) do
      client.request("workspace/executeCommand", {
        command = "cody",
        arguments = { p, command.line1 - 1, command.line2 - 1, command.args, false, true }
      }, function()
      end, 0)
    end
  end, { range = 2, nargs = 1 })

  vim.api.nvim_create_user_command("CodyE", function(command)
    local p = "file://" .. vim.fn.expand('%:p')

    for _, client in pairs(vim.lsp.get_active_clients({ name = "llmsp" })) do
      client.request("workspace/executeCommand", {
        command = "cody.explain",
        arguments = { p, command.line1 - 1, command.line2 - 1, command.args }
      }, function(_, result, _, _)
        vim.lsp.util.open_floating_preview(result.message, "markdown", {
          height = #result.message,
          width = 80,
          focus_id = "codyResponse",
        })
        -- Call it again so that it focuses the window immediately
        vim.lsp.util.open_floating_preview(result.message, "markdown", {
          height = #result.message,
          width = 80,
          focus_id = "codyResponse",
        })
      end, 0)
    end
  end, { range = 2, nargs = 1 })
  vim.api.nvim_create_user_command("CodyEN", function(command)
    local p = "file://" .. vim.fn.expand('%:p')

    for _, client in pairs(vim.lsp.get_active_clients({ name = "llmsp" })) do
      client.request("workspace/executeCommand", {
        command = "cody.explain",
        arguments = { p, command.line1 - 1, command.line2 - 1, command.args }
      }, function(_, result, _, _)
        local opts = {
          height = #result.message,
          width = 80,
          focus_id = "codyResponse",
        }
        table.insert(result.message, 1, "### Explanation")
        vim.lsp.util.open_floating_preview(result.message, "markdown", opts)
        -- Call it again so that it focuses the window immediately
        vim.lsp.util.open_floating_preview(result.message, "markdown", opts)
      end, 0)
    end
  end, { range = 2, nargs = 1 })
end

local read_token = function()
  return require("burm.funcs").read_full(vim.fn.expand("~/.sg-token"))
end

return {
  register_commands = register_commands,
  get_token = read_token
}
