--- Print the internal representation of the thing
P = function(v)
    print(vim.inspect(v))
    return v
end

--- Reload a module
R = function(...)
    print("reloading " .. ...)
    return require("plenary.reload").reload_module(...)
end

local pathlib = require("plenary.path")

local M = {}
M.env_for_key = function(key, default)
    local env = vim.fn.environ()

    for k, v in pairs(env) do
        if k == key then
            return v
        end
    end

    return default
end

M.src_dir = M.env_for_key("SRC", nil)

M.quick_term = function()
    if not M.term_id then
        vim.cmd [[10new]]
        M.term_id = vim.fn.termopen("/bin/zsh")
    else
        -- does this work ?
        vim.fn.win_execute(M.term_id, "close")
    end

    vim.wait(100, function() return false end)
end

M.current_file = function()
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

M.toggle_quickfix = function() toggle_list_window("quickfix", "copen", "cclose") end
M.toggle_loclist = function() toggle_list_window("loclist", "lopen", "lclose") end

M.current_dir = function()
    local file = M.current_file()
    local p = pathlib:new(file)

    return P(p:parent().filename)
end
M.relative_src_dir = function(path)
    local p = pathlib.new(M.src_dir)
    return pathlib.joinpath(p, path).filename
end

M.reload_current = function()
    local current_file = M.current_file()
    local _, e_idx = current_file:find("lua%p", 0)

    if e_idx ~= nil then
        local package_name = current_file:sub(e_idx + 1, #current_file):gsub("/", "."):gsub(".lua", "")
        R(package_name)
    end
end


local Highlighter = { highlight = false }

setmetatable(Highlighter, { __index = {
    toggle_highlight = function(self)
        P(self.highlight)
        self.highlight = not self.highlight
    end,
    do_highlight = function(self)
        P(self.highlight)
        if self.highlight == true then
            vim.lsp.buf.document_highlight()
        end
    end,
    clear_highlight = function(self)
        P(self.highlight)
        if self.highlight == true then
            vim.lsp.buf.clear_references()
        end
    end,
} })

--- export these funcs as the module
return M
