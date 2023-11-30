--- KEYMAPS HERE

local function fuzzyBrowser()
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    previewer = false,
    winblend = 10,
  })
end
local function quickFileBrowser()
  require('telescope.builtin').find_files(
    require('telescope.themes').get_dropdown(
      {
        previewer = false, layout_config = { width = 0.65 }
      })
  )
end

local km = vim.keymap.set

local function general()
  km("n", "<leader>n", ":nohlsearch<CR>")
  km("n", "n", "nzzzv", { noremap = true, desc = "center on next result in search" })
  km("n", "N", "Nzzzv", { noremap = true, desc = "center on previous result in search" })

  km("n", "<tab><leader>", ":tabn<cr>")
  km("n", "<leader><tab>", ":tabp<cr>")
  km("n", "<leader><cr>", ":so ~/.config/nvim/init.lua<cr>")
  --- this should probably be a auto command in lua files
  km("n", "<c-m-r>", require('burm.funcs').reload_current)
  --- QuickFix
  km("n", "]p", ":cnext<cr>")
  km("n", "[p", ":cprev<cr>")
  km("n", "<c-q>", require('burm.funcs').toggle_quickfix)

  km("n", "<leader>.d", require("gitsigns").diffthis, { desc = "[g]it [d]iff this" })
  km("n", "<leader>.D", function() require("gitsigns").diffthis("~") end, { desc = "[g]it [d]iff this with origin" })

  km("n", "<leader>t<enter>", require('telescope.builtin').resume, { desc = "[enter] resume last pick" })
  km("n", "<leader>?", require('telescope.builtin').oldfiles, { desc = "[?] Find recently opened files" })
  km("n", "<leader>/", fuzzyBrowser, { desc = "[/] Fuzzy search in current buffer" })
  km("n", "<leader>gf", require('telescope.builtin').git_files, { desc = "[G]it [F]iles" })
  km("n", "<leader>sf", quickFileBrowser, { desc = "[S]earch [F]iles" })
  km("n", "<leader>sg", require('telescope.builtin').live_grep, { desc = "[S]earch by [G]rep" })
  km("n", "<leader>sl", require('telescope').extensions.live_grep_args.live_grep_args,
    { desc = "[S]earch by [L]ive Grep Args" })
  km("n", "<leader>sw", require('telescope.builtin').grep_string, { desc = "[S]earch [W]ord by grep" })
  km("n", "<leader>sd", function()
    require('telescope.builtin').diagnostics(require('telescope.themes').get_dropdown
    {
      layout_config = { width = 0.80 },
      bufnr = 0
    }
    )
  end, { desc = "[S]earch [D]iagnostics" })
  km("n", "<leader><space>", require('telescope.builtin').buffers, { desc = "[S]earch existings [B]uffers" })
  km("n", "<leader>sh", require('telescope.builtin').help_tags, { desc = "[S]earch [H]elp" })
  km("n", "<leader>df", function()
    require('telescope.builtin').git_files { cwd = '$SRC/dotfiles' }
  end, { desc = "Search [D]ot[F]iles" })
  km("n", "<leader>ss", require('telescope.builtin').lsp_document_symbols, { desc = "[S]earch Document [S]ymbols" })
  km("n", "<leader>si", require('telescope.builtin').lsp_implementations, { desc = "[S]earch [I]mplementation" })
  km("n", "<leader>m", require('harpoon.mark').add_file, { desc = "[M]ark a file" })
  km("n", "<leader>sm", require('harpoon.ui').toggle_quick_menu, { desc = "[S]how [M]arks" })
  -- Cody bindings
  km('n', ',c', '<cmd>CodyChat<cr>', { desc = "Cody [C]hat" })
  km('v', ',e', '<cmd>CodyExplain<cr>', { desc = "Cody [E]xplain" })
  km('n', ',h', '<cmd>CodyHistory<cr>', { desc = "Cody [H]istory" })
  km('n', ',t', '<cmd>CodyToggle<cr>', { desc = "Cody [T]oggle" })
  km('n', ',d', '<cmd>CodyDo', { desc = "Cody [D]o" })

  -- Yank into clipboard
  km("v", "<leader>y", "\"+y")
  km("n", "<leader>p", "\"+p")
  -- Nvim Tree Lua

  km("n", "<leader>n", "<cmd>Neotree toggle reveal_force_cwd<cr>", { desc = "NeoTree Toggle" })

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
  km('n', "<F6>", require('dapui').toggle)
  km('n', "<F10>", require('dap').step_over)
  km('n', "<F11>", require('dap').step_into)
  km('n', "<F12>", require('dap').step_out)
  --- Press CTRL-ESC to exit terminal mode
  km("t", "<Esc><Esc>", '<C-\\><C-n>', { noremap = true })
  --vim.cmd("tnoremap <Esc> <C-\\><C-n>")
end

local function lsp(bufnr)
  local opts = function(desc)
    return { desc = "LSP: " .. desc, buffer = bufnr, noremap = true, silent = true }
  end

  km('n', 'gD', vim.lsp.buf.declaration, opts("[G]oto [D]eclaration"))
  km('n', 'gd', vim.lsp.buf.definition, opts("[G]oto [D]efinition"))
  km('n', 'K', vim.lsp.buf.hover, opts("[H]over Documentation"))
  km('n', 'gi', vim.lsp.buf.implementation, opts("[G]oto [i]mplementation"))
  km('n', 'gr', require('telescope.builtin').lsp_references, opts("[G]oto [r]eferences"))
  km('n', 'gt', vim.lsp.buf.type_definition, opts("[G]oto [t]ype"))
  km('n', '<leader>d', function()
    vim.diagnostic.open_float({ focusable = false })
  end,
    opts("Show [d]iagnostics"))
  km('n', '[d', vim.diagnostic.goto_prev, opts("Prev Diagnostic"))
  km('n', ']d', vim.diagnostic.goto_next, opts("Next Diagnostics"))
  km('n', '<space>re', vim.lsp.buf.rename, opts("[R][e]name"))
  km('n', '<space>ca', vim.lsp.buf.code_action, opts("[C]ode [A]ction"))
  km('v', '<space>ca', vim.lsp.buf.code_action, opts("[C]ode [A]ction"))
  km('n', '<space>ci', vim.lsp.buf.incoming_calls, opts("[I]ncoming [c]alls"))
  km('n', '<space>co', vim.lsp.buf.outgoing_calls, opts("[O]utgoing [c]alls"))
  km('n', '<space>l', vim.diagnostic.setloclist, opts("Diagnostics to Loc List"))
  km('n', '<space>q', vim.diagnostic.setqflist, opts("Diagnostics to QuickFix List"))
  km('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts("Format"))
  km('n', '<leader>wl', function() P(vim.lsp.buf.list_workspace_folders()) end,
    opts("List Workspace Folders"))
  km('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts("[W]orkspace [A]dd folder"))
  km('n', '<leader>wr', vim.lsp.buf.add_workspace_folder, opts("[W]orkspace [R]emove folder"))
  km('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
    opts("[W]orkspace [S]ymbols"))

  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

  if filetype == "go" then
    vim.keymap.set('n', '<leader>ws', function()
      require('telescope.builtin').lsp_workspace_symbols { query = vim.fn.input("Query: ") }
    end, opts("[W]orkspace [S]ymbols"))
  end
end

local M = {
  setup = function(callbacks)
    if not callbacks == nil then
      for _, cb in ipairs(callbacks) do
        cb()
      end
    end
    general()
  end,
  lsp = lsp,
}

return M
