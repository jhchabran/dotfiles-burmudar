PP = function(v)
    print(vim.inspect(v))
    return v
end

local M = {}
M.term_id = nil

local F = {}

F.quick_term = function()
    if not M.term_id then
        vim.cmd [[10new]]
        local cwd = vim.fn.getcwd()
        M.term_id = vim.fn.termopen("/bin/zsh")
    else
        -- does this work ?
        vim.fn.win_execute(M.term_id, "close")
    end

    vim.wait(100, function() return false end)
end

F.current_file = function()
    return vim.fn.expand("%")
end

local function toggle_list_window(key, open_cmd, close_cmd)
    local info = vim.fn.getwininfo()
    local curr_win_nr = vim.api.nvim_win_get_number(0)
    local window_info = info[curr_win_nr]

    if window_info[key] > 0 then
        vim.cmd(close_cmd)
    else
        vim.cmd(open_cmd)
    end
end

F.toggle_quickfix = function() toggle_list_window("quickfix", "copen", "cclose") end
F.toggle_loclist = function() toggle_list_window("loclist", "lopen", "lclose") end

--- export these funcs as the module
return F
