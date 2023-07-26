local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lua/popup.nvim'
  use 'christoomey/vim-tmux-navigator'
  use 'rust-lang/rust.vim'
  use 'ziglang/zig.vim'
  use 'dstein64/vim-startuptime'
  use 'tpope/vim-sensible'
  use 'tpope/vim-surround'
  use 'nvim-lualine/lualine.nvim'
  use 'vim-pandoc/vim-pandoc'
  use 'gruvbox-community/gruvbox'
  use 'sainnhe/everforest'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'nvim-treesitter/playground'
  use 'nvim-treesitter/nvim-treesitter-context'
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-live-grep-args.nvim' } }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use 'onsails/lspkind-nvim'
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use { 'hrsh7th/nvim-cmp', requires = { 'hrsh7th/cmp-nvim-lsp' } }
  use { 'L3MON4D3/LuaSnip', requires = { 'saadparwaiz1/cmp_luasnip' } }
  use 'rhysd/committia.vim'
  use 'kyazdani42/nvim-web-devicons'
  use 'kyazdani42/nvim-tree.lua'
  use 'numToStr/comment.nvim'
  use { 'j-hui/fidget.nvim', tag = 'legacy' }
  use 'mfussenegger/nvim-dap'
  use 'leoluz/nvim-dap-go'
  use 'rcarriga/nvim-dap-ui'
  use 'folke/which-key.nvim'
  use 'folke/lsp-colors.nvim'
  use 'tpope/vim-fugitive'
  use 'ray-x/lsp_signature.nvim'
  use 'folke/trouble.nvim'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'theHamsta/nvim-dap-virtual-text'
  use 'JellyApple102/easyread.nvim'
  use 'ThePrimeagen/harpoon'
  use { 'stevearc/dressing.nvim' }
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
  use { 'ethanholz/nvim-lastplace' }
  use 'mickael-menu/zk-nvim'
  -- use { "nvim-neorg/neorg", run = ":Neorg sync-parsers", requires = "nvim-lua/plenary.nvim" }
  use { "sourcegraph/sg.nvim", run = "nvim -l build/init.lua" }
  if is_bootstrap then
    require('packer').sync()
  end
end)

if is_bootstrap then
  print '====================================='
  print '     Plugins are being installed     '
  print 'After packer is done, restart neovim '
  print '====================================='
  return
end

-- create a autocmd which recompiles packer when this file is changed
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})
