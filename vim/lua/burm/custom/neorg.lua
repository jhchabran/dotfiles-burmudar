local CMD_NEORG_START = "NeorgStart"
local CMD_NEORG_JOURNAL_TODAY = "Neorg journal today"

local find_command = function(name)
    cmds = vim.api.nvim_get_commands({})

    for k,v in pairs(cmds) do
        if k == name then
            return v
        end
    end

    return nil
end

local has_command = function(name)
    return find_command(name) ~= nil
end


local M = {}

M.journal_today = function()
    if has_command(CMD_NEORG_START) then
        vim.api.nvim_command(CMD_NEORG_START .. " silent=true")
    end

    vim.api.nvim_command(CMD_NEORG_JOURNAL_TODAY)
end

return M
