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
require "fidget".setup {}
require('gitsigns').setup({
  numhl = true,
  word_diff = true,
  current_line_blame = true,
})

require 'nvim-web-devicons'.setup {
  default = true
}

--- ident-blankline
require('ibl').setup()

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
        cody = "[cody]",
        path = "[path]",
        luasnip = "[snip]",
        buffer = "[buf]",
      }
    })
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'cody' },
    { name = 'luasnip' },
    { name = 'path' },
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
local bk = require("burm.keymaps")
local on_attach = function(client, bufnr)
  bk.lsp(bufnr)

  if client.server_capabilities.documentHighlightProvider then
    vim.cmd [[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]]
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

local tokenPath = BurmFuncs.relative_home_dir("sg.token")
local init_sg = BurmFuncs.env_for_key("SRC_ACCESS_TOKEN", "") ~= ""
if not init_sg and BurmFuncs.file_exists(tokenPath) then
  P("init..sg" .. tostring(init_sg))
  BurmFuncs.env_set("SRC_ENDPOINT", "https://sourcegraph.com")
  BurmFuncs.env_set("SRC_ACCESS_TOKEN", BurmFuncs.read_full(tokenPath))
  init_sg = true
end

if init_sg then
  P("init..sg - " .. tostring(init_sg))
  require("sg").setup({
    auth_stategy = "environment-variables"
  })
end


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
    ["core.defaults"] = {},
    ["core.concealer"] = {},
    ["core.dirman"] = {
      config = {
        workspaces = {
          notes = "~/code/notes",
        },
      },
    },
    ["core.journal"] = {
      config = {
        folder = "journal",
        strategy = "flat",
        workspace = "notes",
      }
    }
  },
}
-- Remember the last position my cursor was at
require("nvim-lastplace").setup({
  lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
  lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
  lastplace_open_folds = true
})

require('burm.custom.luasnips').configure_snippets()
