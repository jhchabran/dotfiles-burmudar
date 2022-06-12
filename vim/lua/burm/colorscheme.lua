vim.cmd("highlight Normal guibg=dark")
--- order matters, if we put this before colorscheme it only sets certain things
vim.opt.background = "dark"
vim.cmd("colorscheme gruvbox")
