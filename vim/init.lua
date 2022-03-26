require('burm.plugins')
require('burm.funcs')
require('burm.options')
require('burm.colorscheme')
require('burm.config')
require('burm.keymaps')

function reload_all()
    R('burm.funcs')
    R('burm.options')
    R('burm.plugins')
    R('burm.colorscheme')
    R('burm.config')
    R('burm.keymaps')
    print("reloaded all")
end

require('burm.keymaps').setup( { function() vim.keymap.set("n", "<leader>R", reload_all) end } )

