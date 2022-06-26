require('burm.plugins')
require('burm.funcs')
require('burm.options')
require('burm.colorscheme')
require('burm.config')
require('burm.keymaps')
require('burm.autocmd')

function RELOAD_ALL()
    R('burm.funcs')
    R('burm.options')
    R('burm.plugins')
    R('burm.colorscheme')
    R('burm.config')
    R('burm.keymaps')
    R('burm.autocmd')
    print("reloaded all")
end

require('burm.keymaps').setup({ function() vim.keymap.set("n", "<leader>R", RELOAD_ALL) end })

print("config loaded")
