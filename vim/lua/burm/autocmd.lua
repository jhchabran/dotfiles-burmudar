--- Remove trailing whitespace before write
--
vim.cmd([[
    augroup WHITESPACE
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
