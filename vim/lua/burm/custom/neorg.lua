local CMD_NEORG_START = "NeorgStart"
local CMD_NEORG_JOURNAL_TODAY = "Neorg journal today"

local find_command = function(name)
    local cmds = vim.api.nvim_get_commands({})

    for k, v in pairs(cmds) do
        if k == name then
            return v
        end
    end

    return nil
end

local has_command = function(name)
    return find_command(name) ~= nil
end

local run = function(cmd)
    if has_command(CMD_NEORG_START) then
        vim.api.nvim_command(CMD_NEORG_START .. " silent=true")
    end
    if cmd ~= nil then
        vim.api.nvim_command(cmd)
    end
end


local M = {}

M.journal_today = function()
    run(CMD_NEORG_JOURNAL_TODAY)
end

M.open_gtd = function()

    run(nil)
    local tasks = require('neorg.modules.core.gtd.queries.retrievers').public.get('tasks', { bufnr = 1 })
    require('neorg.modules.core.gtd.ui.displayers').public.display_today_tasks(tasks)
end

return M
