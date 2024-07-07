local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node
local s = ls.snippet

M = {}

M.configure_snippets = function()
  ls.add_snippets("go", {
    s("err", fmt(
      [[
if err != nil {
  return <>
}
]],
      { i(1) },
      { delimiters = "<>" }
    )
    )
  })
end

M.expand_or_jump = function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end
M.jump_back = function()
  if ls.jumpable( -1) then
    ls.jump( -1)
  end
end

return M
