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

local function maximizeFocusedWindow()
  local window = hs.window.focusedWindow()
  window:centerOnScreen()
  window:maximize()
end

local function moveWindow(screenNum)
  local screens = hs.screen.allScreens()
  return function()
    local window = hs.window.focusedWindow()
    window:moveToScreen(screens[screenNum])
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
hs.hotkey.bind({ "cmd" }, "4", showFn({ "Firefox", "qutebrowser" }))

hs.hotkey.bind({ "cmd", "shift" }, "1", moveWindow(1))
hs.hotkey.bind({ "cmd", "shift" }, "2", moveWindow(2))

hs.hotkey.bind({ "cmd", "shift" }, "w", maximizeFocusedWindow)
