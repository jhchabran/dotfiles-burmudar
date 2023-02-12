--- Remove trailing whitespace before write
--
vim.cmd([[
    augroup BURM_WHITESPACE
        autocmd!
        autocmd BufWritePre * %s/\s\+$//e
    augroup END
    ]])

vim.cmd([[
    augroup BURM_FORMATTING
        autocmd BufWritePre * :lua vim.lsp.buf.format()
    augroup END
    ]])

vim.cmd([[
    augroup BURM_GOLANG
      autocmd!

      autocmd BufEnter,BufNewFile,BufRead *.go setlocal formatoptions+=roq
      autocmd BufEnter,BufNewFile,BufRead *.go setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4
      autocmd BufEnter,BufNewFile,BufRead *.tmpl setlocal filetype=html
    augroup END
    ]])

vim.cmd([[
    augroup BURN_PYTHON
        autocmd BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
    augroup END
    ]])

vim.cmd([[
    augroup RUST
        autocmd BufNewFile,BufRead *.rs nnoremap <F5> :RustRun<CR>
    augroup END
    ]])


-- nvim_create_user_commands("JFormat", "!jq .")
--
local M = {
    lsp_setup = function(client)
        if client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
            vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
            vim.api.nvim_create_autocmd("CursorHold", {
                callback = vim.lsp.buf.document_highlight,
                buffer = bufnr,
                group = "lsp_document_highlight",
                desc = "Document Highlight",
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                callback = vim.lsp.buf.clear_references,
                buffer = bufnr,
                group = "lsp_document_highlight",
                desc = "Clear All the References",
            })
        end
    end
}

return M
