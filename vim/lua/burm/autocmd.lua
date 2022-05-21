--- Remove trailing whitespace before write
vim.cmd([[
    augroup BURMUDAR
        autocmd!
        autocmd BufWritePre * %s/\s\+$//e
    augroup END
    ]])

vim.cmd([[
    augroup FORMATTING
        autocmd BufWritePre * :lua vim.lsp.buf.format()
    augroup END
    ]])

vim.cmd([[
    augroup PYTHON
        autocmd BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
    augroup END
    ]])

vim.cmd([[
    augroup RUST
        autocmd BufNewFile,BufRead *.rs nnoremap <F5> :RustRun<CR>
    augroup END
    ]])
