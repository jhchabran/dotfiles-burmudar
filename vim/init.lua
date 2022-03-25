local modules = {
    'burm.options',
    'burm.plugins',
    'burm.colorscheme',
    'burm.config',
    'burm.keymaps',
    'burm.funcs',
}

for _, module in ipairs(modules) do
	require(module)
end

require('burm.keymaps').setup( { function() vim.keymap.set("n", "<leader>R", function() require('burm.funcs').reload_all(modules) end) end } )

