local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("burm.options").setup()
require("lazy").setup({
  "nvim-lua/popup.nvim",
  "christoomey/vim-tmux-navigator",
  "tpope/vim-sensible",
  "tpope/vim-surround",
  "tpope/vim-fugitive",
  { "nvim-lualine/lualine.nvim",                opts = { theme = "tokyonight" } },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ':TSUpdate',
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context", "nvim-treesitter/nvim-treesitter-textobjects" }
  },
  "vim-pandoc/vim-pandoc",
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight-storm]])
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-live-grep-args.nvim' }
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      numhl = true,
      word_diff = true,
      current_line_blame = true,
    }
  },
  "onsails/lspkind-nvim",
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },
      'folke/neodev.nvim',
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    }
  },
  {
    "L3MON4D3/LuaSnip",
    branch = "v2.0.0",
    dependencies = { "saadparwaiz1/cmp_luasnip" }
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    config = function()
      require("neo-tree").setup()
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  },
  "folke/which-key.nvim",
  "folke/lsp-colors.nvim",
  "folke/trouble.nvim",
  "ray-x/lsp_signature.nvim",
  "stevearc/dressing.nvim",
  { "sindrets/diffview.nvim",              dependencies = "nvim-lua/plenary.nvim" },
  "ethanholz/nvim-lastplace",
  "ThePrimeagen/harpoon",
  { "lukas-reineke/indent-blankline.nvim", main = "ibl" },
  "numToStr/comment.nvim",
  "rust-lang/rust.vim",
  "ziglang/zig.vim",
  "mfussenegger/nvim-dap",
  "leoluz/nvim-dap-go",
  "rcarriga/nvim-dap-ui",
  "theHamsta/nvim-dap-virtual-text",
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
})
require("burm.keymaps").setup()
require("burm.autocmd")
require("burm.config")
