local BurmFuncs = require('burm.funcs')


require("harpoon").setup({})
-- highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
require "fidget".setup {} --- Do all the plugin setup here
require('gitsigns').setup({
  numhl = true,
  word_diff = true,
  current_line_blame = true,
})

require 'nvim-web-devicons'.setup {
  default = true
}

require("indent_blankline").setup {
  -- for example, context is off by default, use this to turn it on show_current_context = true,
  show_current_context_start = true,
}

--- comment.nvim

--[[ Mappings for Comment
`gcc` - Toggles the current line using linewise comment
`gbc` - Toggles the current line using blockwise comment
`[count]gcc` - Toggles the number of line given as a prefix-count
`gc[count]{motion}` - (Op-pending) Toggles the region using linewise comment
`gb[count]{motion}` - (Op-pending) Toggles the region using linewise comment

VISUAL Mode
`gc` - Toggles the region using linewise comment
`gb` - Toggles the region using blockwise comment

NORMAL Mode
`gco` - Insert comment to the next line and enters INSERT mode
`gcO` - Insert comment to the previous line and enters INSERT mode
`gcA` - Insert comment to end of the current line and enters INSERT mode

]]
--
require('Comment').setup {}

--- Lualine setup
require('lualine').setup {
  options = { theme = 'gruvbox' },
  sections = { lualine_c = { BurmFuncs.current_file } }
}


--- Treesitter config
require('nvim-treesitter.configs').setup {
  ensure_install = { "c99", "c++", "html", "java", "kotlin", "go", "javascript", "typescript", "python", "zig",
    "rust", "lua_ls", "nix", "norg" },
  ignore_install = {},
  highlight = {
    enable = true,
    ident = true,
    --- Disable tree sitter on large files
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  },
  playground = {
    enable = true
  },
  autopairs = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<space>',
      node_incremental = '<space>',
      node_decremental = '<backspace>',
      scope_incremental = '<tab>',
    }
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      }
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.outer',
      }
    },
  },
}

require('treesitter-context').setup({
  enable = true
})

require('nvim-tree').setup({
  update_focused_file = {
    enable = true
  },
  diagnostics = {
    enable = true
  },
})

--- Telescope setup
local lga_actions = require("telescope-live-grep-args.actions")
require('telescope').setup {
  defaults = {
    prompt_prefix = '> ',
    color_devicons = true,
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    mappings = {
      i = {
        ["<C-h>"] = "which_key",
      }
    }
  },
  extensions = {
    fzf_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
    live_grep_args = {
      auto_quoting = true,
      mappings = {
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        }
      }
    },
  },
}


require('telescope').load_extension('fzf')
require('telescope').load_extension('harpoon')
require('telescope').load_extension('live_grep_args')
require('telescope').load_extension('zk')


--- Luasnip
local luasnip = require("luasnip")
luasnip.config.set_config {
  history = true,
  enable_autosnippets = true
}

--- nvim-cmp setup
local lspkind = require('lspkind')
lspkind.init()
local cmp = require 'cmp'
cmp.setup({
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<tab>'] = cmp.config.disable,
    ['<C-y>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true
    },
    ['<C-q>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<C-Space>'] = cmp.mapping.complete,
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  formatting = {
    format = lspkind.cmp_format({
      with_text = true,
      maxwidth = 50,
      mode = "symbol_text",
      menu = {
        nvim_lsp = "[LSP]",
        path = "[path]",
        luasnip = "[snip]",
        buffer = "[buf]",
      }
    })
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'neorg' },
    { name = 'buffer' },
  }, {
    { name = 'buffer' },
  })
})

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})


--- LSP setup
-- LSPConfig setup
local on_attach = function(client, bufnr)
  local opts = function(desc)
    return { desc = "LSP: " .. desc, buffer = bufnr, noremap = true, silent = true }
  end

  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts("[G]oto [D]eclaration"))
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts("[G]oto [D]efinition"))
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts("[H]over Documentation"))
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts("[G]oto [i]mplementation"))
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts("[G]oto [r]eferences"))
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts("[G]oto [t]ype"))
  -- vim.keymap.set('n', '<leader>h', BurmFuncs.toggle_highlight, opts("[h]ighlight"))
  vim.keymap.set('n', '<leader>d', function()
    P("showing diagnostics")
    vim.diagnostic.open_float({ focusable = false })
  end,
    opts("Show [d]iagnostics"))
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts("Prev Diagnostic"))
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts("Next Diagnostics"))
  vim.keymap.set('n', '<space>re', vim.lsp.buf.rename, opts("[R][e]name"))
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts("[C]ode [A]ction"))
  vim.keymap.set('v', '<space>ca', vim.lsp.buf.code_action, opts("[C]ode [A]ction"))
  vim.keymap.set('n', '<space>ci', vim.lsp.buf.incoming_calls, opts("[I]ncoming [c]alls"))
  vim.keymap.set('n', '<space>co', vim.lsp.buf.outgoing_calls, opts("[O]utgoing [c]alls"))
  vim.keymap.set('n', '<space>l', vim.diagnostic.setloclist, opts("Diagnostics to Loc List"))
  vim.keymap.set('n', '<space>q', vim.diagnostic.setqflist, opts("Diagnostics to QuickFix List"))
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts("Format"))
  vim.keymap.set('n', '<leader>wl', function() P(vim.lsp.buf.list_workspace_folders()) end,
    opts("List Workspace Folders"))
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts("[W]orkspace [A]dd folder"))
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.add_workspace_folder, opts("[W]orkspace [R]emove folder"))
  vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
    opts("[W]orkspace [S]ymbols"))

  vim.keymap.set('n', ',c', '<cmd>CodyChat<cr>', opts("Cody chat"))
  vim.keymap.set('n', ',e', '<cmd>CodyExplain<cr>', opts("Cody chat"))
  vim.keymap.set('n', ',h', '<cmd>CodyHistory<cr>', opts("Cody chat [H]istory"))
  vim.keymap.set('n', ',t', '<cmd>CodyToggle<cr>', opts("Toggle Cody [C]chat"))

  if client.server_capabilities.documentHighlightProvider then
    vim.cmd [[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]]
  end

  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

  if filetype == "go" then
    vim.keymap.set('n', '<leader>ws', function()
      require('telescope.builtin').lsp_workspace_symbols { query = vim.fn.input("Query: ") }
    end, opts("[W]orkspace [S]ymbols"))
  end
end

local servers = { "pyright", "gopls", "clangd", "tsserver", "zls", "rust_analyzer", "lua_ls", "nil_ls" }
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

local configs = {
  default = {
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities),
    on_attach = on_attach
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim', 'hs' },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true)
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  },
  gopls = {
    flags = { debounce_text_changes = 200 },
    settings = {
      gopls = {
        completeUnimported = true,
        buildFlags = { "-mod=readonly", "-tags=debug" },
        ["local"] = "github.com/sourcegraph/sourcegraph",
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
        experimentalPostfixCompletions = true,
        codelenses = { test = true },
        hints = {
          parameterNames = true,
          assignVariableTypes = true,
          constantValues = true,
          rangeVariableTypes = true,
          compositeLiteralTypes = true,
          compositeLiteralFields = true,
          functionTypeParameters = true,
        },
      },
    },
  }
}



for _, lsp in ipairs(servers) do
  local c = configs.default
  if configs[lsp] ~= nil then
    c = configs[lsp]
    c.on_attach = configs.default.on_attach
    c.capabilities = configs.default.capabilities
  end

  require('lspconfig')[lsp].setup(c)
end

require("sg").setup()

-- null-ls
-- DISABLED: incurs a performance hit
-- require('null-ls').setup({
--     sources = {
--         require('null-ls').builtins.diagnostics.golangci_lint,
--     }
-- })


--- Highlights
--- vim.cmd [[highlight LspReferenceText cterm=reverse ctermfg=214 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828]]
-- Black background white foreground
--- vim.cmd [[highlight LspReferenceText cterm=reverse ctermfg=0 ctermbg=255 gui=reverse guifg=#000000 guibg=#ffffff]]

-- Trouble
require('trouble').setup({})

-- Mason, use :Mason to open up the window
require("mason").setup()

local dap, dapui = require("dap"), require("dapui")
-- require("nvim-dap-virtual-text").setup() this throws a cannot allocate memory error in delv
dapui.setup()
vim.fn.sign_define('DapBreakpoint', { text = '🧪', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '🔍', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '👉', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '🛑', texthl = '', linehl = '', numhl = '' })
require('dap-go').setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close({})
end

-- Diagnostics
vim.diagnostic.config({
  underline = true,
  virtual_text = true,
  signs = true,
})

-- Notes
vim.env.ZK_NOTEBOOK_DIR = vim.fs.normalize("~/code/notes")
require("zk").setup()

-- Neorg
require('neorg').setup {
  load = {
    ["core.defaults"] = {}, -- Loads default behaviour
    ["core.concealer"] = {}, -- Adds pretty icons to your documents
    ["core.dirman"] = { -- Manages Neorg workspaces
      config = {
        workspaces = {
          notes = "~/code/notes",
        },
      },
    },
  },
}
-- Remember the last position my cursor was at
require("nvim-lastplace").setup({
  lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
  lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
  lastplace_open_folds = true
})
