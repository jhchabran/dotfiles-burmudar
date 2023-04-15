local function showFn(hint)
  local names = {}
  if type(hint) ~= "table" then
    table.insert(names, hint)
  else
    names = hint
  end
  return function()
    for _, name in ipairs(names) do
      local app = hs.application.find(name)
      if app then
        app:activate()
        return
      end
    end
  end
end

hs.hotkey.bind({ "cmd" }, "1", showFn({ "kitty", "alacritty" }))
hs.hotkey.bind({ "cmd" }, "2", function()
  local zoom = hs.application.find("zoom")
  if zoom then
    local win = zoom:findWindow("Zoom Meeting")
    win:focus()
  end
end)

hs.hotkey.bind({ "cmd" }, "3", showFn("slack"))
hs.hotkey.bind({ "cmd" }, "4", showFn("qutebrowser"))
