M = {}

local ls = require('luasnip')

M.expand_or_jump = function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end
M.jump_back = function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end

return M
