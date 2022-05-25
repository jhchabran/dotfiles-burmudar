--- KEYMAPS HERE
local km = vim.keymap.set

km("n", "<C-tab>", ":tabn<cr>")
km("n", "<C-S-tab>", ":tabp<cr>")
km("i", "<C-tab>", ":tabn<cr>")
km("i", "<C-S-tab>", ":tabp<cr>")
km("n", "<leader>tt", ":tabnew<cr>")
km("n", "<leader><cr>", ":so ~/.config/nvim/init.lua<cr>")
--- this should probably be a auto command in lua files
km("n", "<c-r>", "<cmd>lua require('burm.funcs').reload_current()<cr>")
km("n", "]p", ":cnext<cr>")
km("n", "[p", ":cprev<cr>")
km("n", "<c-q>", "<cmd>lua require('burm.funcs').toggle_quickfix()<cr>")
km("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({previewer=false, layout_config={width=0.65}}))<cr>")
km("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
km("n", "<leader>dd", "<cmd>lua require('telescope.builtin').diagnostics(require('telescope.themes').get_dropdown({layout_config={width=0.80}}), {bufnr=0})<cr>")
km("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>")
km("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>")
km("n", "<leader>gf", "<cmd>lua require('telescope.builtin').git_files()<cr>")
km("n", "<leader>df", "<cmd>lua require('telescope.builtin').git_files( { cwd = '$SRC/dotfiles' } )<cr>")
km("n", "<leader>ds", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>")
km("n", "<leader>gs", "<cmd>lua require('telescope.builtin').git_status()<cr>")
km("n", "<leader>j", "<cmd>lua require('burm.custom.neorg').journal_today()<cr>")
-- Yank into clipboard
km("v", "<leader>y", "\"+y")
km("n", "<leader>p", "\"+p")
-- Nvim Tree Lua
km("n", "<C-n>", ":NvimTreeToggle<cr>")
km("n", "<leader>r", ":NvimTreeRefresh<cr>")

km("i", "<C-k>", '<cmd>lua require("burm.custom.luasnips").expand_or_jump()<CR>', { silent = true })
km("s", "<C-k>", '<cmd>lua require("burm.custom.luasnips").expand_or_jump()<CR>', { silent = true })

km("i", "<C-j>", '<cmd>lua require("burm.custom.luasnips").jump_back()<CR>', { silent = true })
km("s", "<C-j>", '<cmd>lua require("burm.custom.luasnips").jump_back()<CR>', { silent = true })
--- Debugging
km('n', "<leader>b", "<cmd>lua require('dap').toggle_breakpoint()<CR>")
km('n', "<leader>B", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
km('n', "<F5>", "<cmd>lua require('dap').continue()<CR>")
km('n', "<F10>", "<cmd>lua require('dap').step_over()<CR>")
km('n', "<F11>", "<cmd>lua require('dap').step_into()<CR>")
km('n', "<F12>", "<cmd>lua require('dap').step_out()<CR>")
--- Press CTRL-ESC to exit terminal mode
km("t", "<Esc>", '<C-\\><C-n>', { noremap = true })
--vim.cmd("tnoremap <Esc> <C-\\><C-n>")

local M = {
    setup = function(cbs)
        for _, cb in ipairs(cbs) do
            cb()
        end
    end
}

return M
