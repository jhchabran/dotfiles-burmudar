local BurmFuncs = require('burm.funcs')

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

--- Do all the plugin setup here
require('gitsigns').setup()

require 'nvim-web-devicons'.setup {
    default = true
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

]] --
require('Comment').setup {}

--- Lua tree
require('nvim-tree').setup {}

--- Lualine setup
require('lualine').setup {
    options = { theme = 'gruvbox' },
    sections = { lualine_c = { BurmFuncs.current_file } }
}


--- Treesitter config
local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

parser_configs.norg = {
    install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg",
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "main"
    },
}

require('nvim-treesitter.configs').setup {
    ensure_install = { "c99", "c++", "html", "java", "kotlin", "go", "javascript", "typescript", "python", "norg", "zig",
        "rust", "sumneko_lua" },
    ignore_install = {},
    highlight = {
        enable = true,
        ident = true
    },
    playground = {
        enable = true
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<c-backspace>',
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

--- Telescope setup
require('telescope').setup {
    defaults = {
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        prompt_prefix = '> ',
        color_devicons = true,

        file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }
}


require('telescope').load_extension('fzf')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}


--- Luasnip
local ls = require("luasnip")
ls.config.set_config {
    history = true,
    enable_autosnippets = true
}


--- nvim-cmp setup
local lspkind = require('lspkind')
lspkind.init()
local cmp = require 'cmp'
cmp.setup({
    mapping = {
        ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
        ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<tab>'] = cmp.config.disable,
        ['<C-y>'] = cmp.mapping(
            cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true
            }),
            { "i", "c" }
        ),
        ['<C-q>'] = cmp.mapping(
            cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }),
            { 'i', 'c' }
        ),
        ['<C-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    },
    formatting = {
        format = lspkind.cmp_format({
            with_text = true, maxwidth = 50,
            menu = {
                buffer = "[buf]",
                nvim_lsp = "[LSP]",
                path = "[path]",
                luasnip = "[snip]",
                neorg = "[neorg]",
            }
        })
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = "path" },
        { name = "neorg" },
        { name = 'buffer' },
    },
    snippet = {
        expand = function(args)
            ls.lsp_expand(args.body)
        end
    },
    experimental = {
        native_menu = false,
        ghost_text = false,
    }
})

local doc_highlight = function()
    local highlighted = false

    return function()
        if highlighted == false then
            vim.lsp.buf.document_highlight()
            highlighted = true
        else
            vim.lsp.buf.clear_references()
            highlighted = false
        end

    end

end

--- LSP setup
-- LSPConfig setup
local on_attach = function(_, bufnr)
    local opts = function(desc)
        return { desc = "LSP: " .. desc, buffer = bufnr, noremap = true, silent = true }
    end
    require('lsp_signature').on_attach()

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts("[G]oto [D]eclaration"))
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts("[G]oto [D]efinition"))
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts("[H]over Documentation"))
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts("[G]oto [i]mplementation"))
    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts("[G]oto [r]eferences"))
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts("[G]oto [t]ype"))
    vim.keymap.set('n', '<leader>h', doc_highlight(), opts("[h]ighlight"))
    vim.keymap.set('n', '<leader>d', function()
        P("showing diagnostics")
        vim.diagnostic.open_float({ focusable = false })
    end,
        opts("Show [d]iagnostics"))
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts("Prev Diagnostic"))
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts("Next Diagnostics"))
    vim.keymap.set('n', '<space>re', vim.lsp.buf.rename, opts("[R][e]name"))
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts("[C]ode [A]ction"))
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

    local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

    if filetype == "go" then
        vim.keymap.set('n', '<leader>ws', function()
            require('telescope.builtin').lsp_workspace_symbols { query = vim.fn.input("Query: ") }
        end, opts("[W]orkspace [S]ymbols"))
    end


end

local servers = { "pyright", "gopls", "clangd", "tsserver", "zls", "rust_analyzer", "sumneko_lua" }

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local configs = {
    default = {
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
        on_attach = on_attach
    },
    sumneko_lua = {
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = runtime_path,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { 'vim' },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    gopls = {
        completeUnimported = true,
        buildFlags = { "-tags=debug" },
        ["local"] = "github.com/sourcegraph/sourcegraph",
        analyses = {
            unusedparams = true,
        },
        staticcheck = true,
        experimentalPostfixCompletions = true,
    },
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

--- Neorg setup
require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.keybinds"] = {},
        ["core.norg.concealer"] = {},
        ["core.norg.completion"] = {
            config = {
                engine = "nvim-cmp"
            }
        },
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    notes = BurmFuncs.relative_src_dir("notes"),
                    gtd = BurmFuncs.relative_src_dir("notes/gtd")
                },
            },
        },
        ["core.norg.journal"] = {
            config = {
                workspace = "notes",
            }
        },
        ["core.gtd.base"] = {
            config = {
                workspace = "gtd",
            }
        }
    }
}

---local D = require('dap')
---D.set_log_level("TRACE")
vim.fn.sign_define('DapBreakpoint', { text = '🧪', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '🔍', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '👉', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '🛑', texthl = '', linehl = '', numhl = '' })
require('dap-go').setup()

require("which-key").setup({})

--- Highlights
vim.cmd [[highlight LspReferenceText cterm=reverse ctermfg=214 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828]]
