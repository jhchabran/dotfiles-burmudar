set exrc
set guicursor=
set relativenumber
set hidden
set nohlsearch
set number
set cursorline
set showmatch
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set nu
set smartindent
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode
set signcolumn=yes
set colorcolumn=120
"silent pattern not found in compe
set shortmess+=c
set completeopt=menuone,noselect
let g:completetion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

set updatetime=50

call plug#begin('~/.config/nvim/plugged')
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'fatih/vim-go'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-pandoc/vim-pandoc'
Plug 'gruvbox-community/gruvbox'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
call plug#end()

lua <<EOF
require('nvim-treesitter.configs').setup {
    ensure_install = { "java", "kotlin", "go", "javascript", "typescript" },
    ignore_install = {},
    highlight = {
        enable = true,
        ident = true
    }
}

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

require'nvim-web-devicons'.setup {
    default = true
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

require('lspconfig').gopls.setup{ capabilities = capabilities, }

require('compe').setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;

    source = {
        path = true;
        buffer = true;
        calc = true;
        nvim_lsp = true;
        nvim_lua = true;
        ultisnips = true;
    };
}
EOF

set background=dark
highlight Normal guibg=dark
colorscheme gruvbox

filetype plugin indent on
syntax on

let mapleader = " "

" nnoremap <leader>ff <cmd>Telescope find_files<cr>
" nnoremap <leader>fg <cmd>Telescope live_grep<cr>
" nnoremap <leader>fb <cmd>Telescope buffers<cr>
" nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>
nnoremap <leader>cwd :lcd %:p:h<CR>
nnoremap <leader>fp <cmd>lua require('telescope.builtin').file_browser({ cwd = "$SRC", depth = 1 })<cr>
nnoremap <leader>ff :lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

let g:airline#extensions#syntastic#enabled = 1

"golang config
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>gb <Plug>(go-doc-browser)

"compe mappings
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR> compe#confirm('<CR>')
inoremap <silent><expr> <C-e> compe#close('<C-e>')
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <C-Space> compe#complete()

augroup BURMUDAR
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e
augroup END
