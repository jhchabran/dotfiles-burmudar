config.load_autoconfig()

# stop closing things by mistake
config.unbind('d', mode='normal')
config.bind(',d', 'tab-close')

c.input.insert_mode.auto_load = True
c.input.insert_mode.auto_leave = True

c.tabs.favicons.scale = 1.0
c.tabs.width = 250
c.tabs.padding = {"bottom": 5, "left": 5, "right": 5, "top": 5}
c.tabs.position = "right"
# when the tab is selected make it more visible
c.fonts.tabs.selected = '14pt default_family'
c.fonts.tabs.unselected = '10pt default_family'

# with config.pattern("*://github.com") as p:
#     try:
#         p.content.javascript.clipboard = 'access'
#     except:
#         pass
#         # guess it doesn't exist

c.url.searchengines = {
            "DEFAULT": "https://duckduckgo.com/?q={}",
            "s": "https://sourcegraph.sourcegraph.com/search?q=context:global+{}&patternType=regexp",
            "ss": "https://sourcegraph.com/search?q=context:global+{}&patternType=regexp",
            "g": "https://google.com/search?q={}",
            "gif": "https://giphy.com/search/{}",
         }

def rutorrent():
    import pathlib
    try:
        p = pathlib.Path("~/.rutorrent").expanduser()
        with open(p) as f:
            creds = f.read()
        return creds.rstrip()
    except:
        return "burmudar:EMPTY"


config.bind(',1', "open https://mail.google.com")
config.bind(',2', "open https://calendar.google.com")
config.bind(',3', "open https://github.com")
config.bind(',4', "open https://sourcegraph.sourcegraph.com")
config.bind(',5', "open https://sourcegraph.com")
config.bind(',6', "open https://sourcegraph.test:3443")
config.bind(',7', f"open https://{rutorrent()}@leon.feralhosting.com/burmudar/rutorrent/")
config.bind('tt', 'set-cmd-text -s :tab-select')
