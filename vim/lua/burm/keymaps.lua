--- KEYMAPS HERE
local km = vim.keymap.set

km("n", "<tab>", ":tabn<cr>")
km("n", "<s-tab>", ":tabp<cr>")
km("n", "<leader>t", ":tabnew<cr>")
km("n", "<leader><cr>", ":so ~/.config/nvim/init.lua<cr>")
--- this should probably a auto command in lua files
km("n", "<c-r>", "<cmd>lua require('burm.funcs').reload_current()<cr>")
km("n", "]p", ":cnext<cr>")
km("n", "[p", ":cprev<cr>")
km("n", "<c-q>", "<cmd>lua require('burm.funcs').toggle_quickfix()<cr>")
km("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({previewer=false, layout_config={width=0.65}}))<cr>")
km("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
km("n", "<leader>fd", "<cmd>lua require('telescope.builtin').diagnostics(require('telescope.themes').get_dropdown({layout_config={width=0.80}}), {bufnr=0})<cr>")
km("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>")
km("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>")
km("n", "<leader>gf", "<cmd>lua require('telescope.builtin').git_files()<cr>")
km("n", "<leader>df", "<cmd>lua require('telescope.builtin').git_files( { cwd = '$SRC/dotfiles' } )<cr>")
km("n", "<leader>ds", "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>")
km("n", "<leader>j", "<cmd>lua require('burm.custom.neorg').journal_today()<cr>")
-- Yank into clipboard
km("v", "<leader>y", "+y")
km("n", "<leader>p", "+p")
--- Nvim Tree Lua
km("n", "<C-n>", ":NvimTreeToggle<cr>")
km("n", "<leader>r", ":NvimTreeRefresh<cr>")

km("i", "<C-k>", '<cmd>lua require("burm.custom.luasnips").expand_or_jump()<CR>', { silent = true })
km("s", "<C-k>", '<cmd>lua require("burm.custom.luasnips").expand_or_jump()<CR>', { silent = true })

km("i", "<C-j>", '<cmd>lua require("burm.custom.luasnips").jump_back()<CR>', { silent = true})
km("s", "<C-j>", '<cmd>lua require("burm.custom.luasnips").jump_back()<CR>', { silent = true})
local M = {
    setup = function(cbs)
        for _, cb in ipairs(cbs) do
            cb()
        end
    end
}

return M
