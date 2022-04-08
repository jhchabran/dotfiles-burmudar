vim.g.mapleader = " "
vim.g.maplocaleader = " "
vim.g.rustfmt_autosave = 1

vim.opt.exrc = true
vim.opt.guicursor = ""
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.hidden = true
vim.opt.hlsearch = false
vim.opt.cursorline = true
vim.opt.showmatch = true
vim.opt.errorbells = false
vim.opt.showtabline = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.nu = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "120"
vim.opt.splitbelow = true
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.clipboard = "unnamedplus"
-- silent pattern not found in compe
vim.opt.shortmess:append("c")
vim.g.completetion_matching_strategy_list = "fuzzy, substring, exact"
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.list = true
vim.opt.listchars = "tab:»·,eol:↲,nbsp:␣"

vim.opt.updatetime = 50
vim.opt.syntax = "enable"

