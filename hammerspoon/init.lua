hs.hotkey.bind({ "cmd" }, "1", function()
  local terminal = hs.application.find("kitty")
  if not terminal then
    terminal = hs.application.find("alacritty")
  end
  show(terminal)
end)

hs.hotkey.bind({ "cmd" }, "2", function()
  local zoom = hs.application.find("zoom")
  if zoom then
    local win = zoom:findWindow("Zoom Meeting")
    show(win)
  end
end)

hs.hotkey.bind({ "cmd" }, "3", function()
  local slack = hs.application.find("slack")
  show(slack)
end)

hs.hotkey.bind({ "cmd" }, "4", function()
  local browser = hs.application.find("qutebrowser")
  show(browser)
end)

function show(target)
  if target.activate then
    target:activate()
    return
  end
  if target.focus then
    target:focus()
    return
  end
end
