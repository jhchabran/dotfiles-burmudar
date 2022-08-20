--- KEYMAPS HERE
local km = vim.keymap.set

local fileBrowser = function()
    require('telescope._extensions').file_browser.file_browser({
        no_ignore = true,
        no_ignore_parent = true
    })
end
local fuzzyBrowser = function()
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        previewer = false,
        winblend = 10,
    })
end
local quickFileBrowser = function()
    require('telescope.builtin').find_files(
        require('telescope.themes').get_dropdown(
            { previewer = false, layout_config = { width = 0.65 }
            })
    )
end

km("n", "<C-tab>", ":tabn<cr>")
km("n", "<C-S-tab>", ":tabp<cr>")
km("i", "<C-tab>", ":tabn<cr>")
km("i", "<C-S-tab>", ":tabp<cr>")
km("n", "<leader>t", require('burm.custom.neorg').open_gtd, { desc = "open gtd [t]asks" })
km("n", "<leader><cr>", ":so ~/.config/nvim/init.lua<cr>")
--- this should probably be a auto command in lua files
km("n", "<c-m-r>", require('burm.funcs').reload_current)
km("n", "]p", ":cnext<cr>")
km("n", "[p", ":cprev<cr>")
km("n", "<c-q>", require('burm.funcs').toggle_quickfix)

km("n", "<leader>.", fileBrowser, { desc = "File browser" })
km("n", "<leader>?", require('telescope.builtin').oldfiles, { desc = "[?] Find recently opened files" })
km("n", "<leader>/", fuzzyBrowser, { desc = "[/] Fuzzy search in current buffer" })
km("n", "<leader>gf", require('telescope.builtin').git_files, { desc = "[G]it [F]iles" })
km("n", "<leader>sf", quickFileBrowser, { desc = "[S]search [F] files" })
km("n", "<leader>sg", require('telescope.builtin').live_grep, { desc = "[S]earch by [G]rep" })
km("n", "<leader>sw", require('telescope.builtin').grep_string, { desc = "[S]earch [W]ord by grep" })
km("n", "<leader>sd", function()
    require('telescope.builtin').diagnostics(require('telescope.themes').get_dropdown
        {
            layout_config = { width = 0.80 },
            bufnr = 0
        }
    )
end, { desc = "[S]search [D]iagnostics" })
km("n", "<leader><space>", require('telescope.builtin').buffers, { desc = "[S]earch existings [B]uffers" })
km("n", "<leader>sh", require('telescope.builtin').help_tags, { desc = "[S]earch [H]elp" })
km("n", "<leader>df", function()
    require('telescope.builtin').git_files { cwd = '$SRC/dotfiles' }
end, { desc = "Search [D]ot[F]iles" })
km("n", "<leader>ss", require('telescope.builtin').lsp_document_symbols, { desc = "[S]earch Document [S]ymbols" })
km("n", "<leader>j", require('burm.custom.neorg').journal_today)
-- Yank into clipboard
km("v", "<leader>y", "\"+y")
km("n", "<leader>p", "\"+p")
-- Nvim Tree Lua
km("n", "<C-n>", ":NvimTreeToggle<cr>")
km("n", "<leader>r", ":NvimTreeRefresh<cr>")

km("i", "<C-k>", '<cmd>lua require("burm.custom.luasnips").expand_or_jump<CR>', { silent = true })
km("s", "<C-k>", '<cmd>lua require("burm.custom.luasnips").expand_or_jump<CR>', { silent = true })

km("i", "<C-j>", '<cmd>lua require("burm.custom.luasnips").jump_back<CR>', { silent = true })
km("s", "<C-j>", '<cmd>lua require("burm.custom.luasnips").jump_back<CR>', { silent = true })
-- Trouble
km("n", "<leader>tt", "<cmd>Trouble<cr>", { silent = true })
km("n", "<leader>tw", "<cmd>Trouble workspace_diagnostics<cr>", { silent = true })
km("n", "<leader>td", "<cmd>Trouble document_diagnostics<cr>", { silent = true })
--- Debugging
km('n', "<leader>b", require('dap').toggle_breakpoint)
km('n', "<leader>B", function()
    require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
end)
km('n', "<F5>", require('dap').continue)
km('n', "<F10>", require('dap').step_over)
km('n', "<F11>", require('dap').step_into)
km('n', "<F12>", require('dap').step_out)
--- Press CTRL-ESC to exit terminal mode
km("t", "<Esc>", '<C-\\><C-n>', { noremap = true })
--vim.cmd("tnoremap <Esc> <C-\\><C-n>")

local M = {
    setup = function(cbs)
        for _, cb in ipairs(cbs) do
            cb()
        end
    end,

}

return M
