
local M = {}
M.term_id = nil

function QuickTerm()
    if not M.term_id then
        vim.cmd [[10new]]
        cwd = vim.fn.getcwd()
        M.term_id = vim.fn.termopen("/bin/zsh")
    else
        -- does this work ?
        vim.fn.win_execute(M.term_id, "close")
    end

    vim.wait(100, function() return false end)
end

--- Do all the plugin setup here
require('gitsigns').setup()

require'nvim-web-devicons'.setup {
    default = true
}

local function current_file()
    return vim.fn.expand("%")
end

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

]]--
require('Comment').setup {}

--- Lua tree
require('nvim-tree').setup {}

--- Lualine setup
require('lualine').setup {
    options = { theme = 'gruvbox' },
    sections = { lualine_c = { current_file } }
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
    ensure_install = { "c99", "c++", "html", "java", "kotlin", "go", "javascript", "typescript", "python", "norg", "zig", "rust" },
    ignore_install = {},
    highlight = {
        enable = true,
        ident = true
    },
    playground = {
        enable = true
    }
}

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


require('telescope').load_extension('fzy_native')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
    }
}

-- LSPConfig setup
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <C-x><C-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap=true, silent=true }

    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-s>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', 'dr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>r', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

--- nvim-cmp setup
local ls = require"luasnip"
local lspkind = require('lspkind')
lspkind.init()
local cmp = require'cmp'
cmp.setup({
    mapping = {
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
            }),
        ['<tab>'] = cmp.config.disable,
        ['<C-y>'] = cmp.mapping (
            cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true
            }),
            { "i", "c" }
        ),
        ['<C-q>'] = cmp.mapping(
            cmp.mapping.confirm( {
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

--- LSP setup
local servers = { "pyright", "gopls","clangd","tsserver", "zls", "rust_analyzer"}
for _, lsp in ipairs(servers) do
    require('lspconfig')[lsp].setup(
    {
            capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
            on_attach = on_attach }
    )
end

--- Luasnip
ls.config.set_config {
    history = true,
    enable_autosnippets = true
    }

UTIL = {
    luasnips = {
        expand_or_jump = function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end,
        jump_back = function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end
    },
}
--- Expand using C-k or got to the next one
vim.api.nvim_set_keymap("i", "<C-k>", '<cmd>lua UTIL.luasnips.expand_or_jump()<CR>', { silent = true })
vim.api.nvim_set_keymap("s", "<C-k>", '<cmd>lua UTIL.luasnips.expand_or_jump()<CR>', { silent = true })

vim.api.nvim_set_keymap("i", "<C-j>", '<cmd>lua UTIL.luasnips.jump_back()<CR>', { silent = true})
vim.api.nvim_set_keymap("s", "<C-j>", '<cmd>lua UTIL.luasnips.jump_back()<CR>', { silent = true})


--- Neorg setup
require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.norg.concealer"] = {},
        ["core.norg.completion"] = {
            config = {
                engine = "nvim-cmp"
            }
        },
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    my_workspace = "$SRC/neorg"
                },
            },
        },
    }
}


