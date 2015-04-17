set nocompatible 

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'sjl/badwolf'
Plug 'kien/ctrlp.vim'
Plug 'fatih/vim-go'
Plug 'majutsushi/tagbar'
Plug 'Shougo/neocomplete.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'klen/python-mode'
Plug 'spf13/PIV'
Plug 'scrooloose/syntastic'
call plug#end()

colorscheme badwolf

" editing config
set tabstop=4
set softtabstop=4
set expandtab

"UI config
set number
set cursorline
set showmatch
"sensible already sets incsearch
set hlsearch "to clear hlsearch press <C-L>

"Keybinds
let mapleader = ","

nmap <F8> :TagbarToggle<CR>

let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
" TAB completion
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" <Space> or Backspace closes completion popup
inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
