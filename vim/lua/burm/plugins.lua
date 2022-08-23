local PLUGINS = {
    { name = 'nvim-lua/plenary.nvim' },
    { name = 'nvim-lua/popup.nvim' },
    { name = 'christoomey/vim-tmux-navigator' },
    { name = 'rust-lang/rust.vim' },
    { name = 'ziglang/zig.vim' },
    { name = 'dstein64/vim-startuptime' },
    { name = 'tpope/vim-sensible' },
    { name = 'tpope/vim-surround' },
    { name = 'nvim-lualine/lualine.nvim' },
    { name = 'vim-pandoc/vim-pandoc' },
    { name = 'gruvbox-community/gruvbox' },
    { name = 'sainnhe/everforest' },
    { name = 'nvim-treesitter/nvim-treesitter', opts = { ['do'] = ':TSUpdate' } },
    { name = 'nvim-treesitter/playground' },
    { name = 'nvim-treesitter/nvim-treesitter-context' },
    { name = 'lewis6991/gitsigns.nvim' },
    { name = 'nvim-telescope/telescope.nvim' },
    { name = 'nvim-telescope/telescope-fzf-native.nvim',
        opts = { ['do'] = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' } },
    { name = 'onsails/lspkind-nvim' },
    { name = 'neovim/nvim-lspconfig' },
    { name = 'hrsh7th/cmp-nvim-lsp' },
    { name = 'hrsh7th/cmp-buffer' },
    { name = 'hrsh7th/cmp-path' },
    { name = 'hrsh7th/cmp-cmdline' },
    { name = 'hrsh7th/nvim-cmp' },
    { name = 'L3MON4D3/LuaSnip' },
    { name = 'saadparwaiz1/cmp_luasnip' },
    { name = 'rhysd/committia.vim' },
    { name = 'nvim-neorg/neorg' },
    { name = 'kyazdani42/nvim-web-devicons' },
    { name = 'kyazdani42/nvim-tree.lua' },
    { name = 'numToStr/comment.nvim' },
    { name = 'j-hui/fidget.nvim' },
    { name = 'mfussenegger/nvim-dap' },
    { name = 'leoluz/nvim-dap-go' },
    { name = 'folke/which-key.nvim' },
    { name = 'folke/lsp-colors.nvim' },
    { name = 'tpope/vim-fugitive' },
    { name = 'ray-x/lsp_signature.nvim' },
    { name = 'nvim-treesitter/nvim-treesitter-textobjects' },
    { name = 'folke/trouble.nvim' },
    { name = 'lukas-reineke/indent-blankline.nvim' },
}

local function plug_all(plugins)
    local Plug = vim.fn['plug#']

    vim.call("plug#begin")
    for _, plugin in ipairs(plugins) do
        if plugin.opts then
            Plug(plugin.name, plugin.opts)
        else
            Plug(plugin.name)
        end
    end
    vim.call("plug#end")
end

local ran, errorMsg = pcall(plug_all, PLUGINS)
if not ran then
    error("Function errored on run " .. "\n" .. errorMsg)
end

return PLUGINS
