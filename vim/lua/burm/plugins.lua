local PLUGINS = {
    'nvim-lua/plenary.nvim',
    'nvim-lua/popup.nvim',
    'christoomey/vim-tmux-navigator',
    'rust-lang/rust.vim',
    'rust-lang/rust.vim',
    'ziglang/zig.vim',
    'dstein64/vim-startuptime',
    'tpope/vim-sensible',
    'tpope/vim-surround',
    'nvim-lualine/lualine.nvim',
    'vim-pandoc/vim-pandoc',
    'gruvbox-community/gruvbox',
    {'nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'}},
    'nvim-treesitter/playground',
    'nvim-lua/popup.nvim',
    'lewis6991/gitsigns.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-telescope/telescope-fzy-native.nvim',
    'onsails/lspkind-nvim',
    'neovim/nvim-lspconfig',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/nvim-cmp',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'rhysd/committia.vim',
    'nvim-neorg/neorg',
    'kyazdani42/nvim-web-devicons',
    'kyazdani42/nvim-tree.lua',
    'numToStr/comment.nvim'
}

local function plug_all(plugins)
    local Plug = vim.fn['plug#']

    vim.call("plug#begin")
    for _, plugin in ipairs(plugins) do
        if (type(plugin) == "table") then
            Plug(plugin[1], plugin[2])
        else
            Plug(plugin)
        end
    end
    vim.call("plug#end")
end

local ran, errorMsg = pcall( plug_all, PLUGINS )
if not ran then
    error("Function errored on run " .. "\n" .. errorMsg)
end
