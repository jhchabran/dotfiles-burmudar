config.load_autoconfig()

# stop closing things by mistake
config.unbind('d', mode='normal')
config.bind(',d', 'tab-close')

c.input.insert_mode.auto_load = True
c.input.insert_mode.auto_leave = True

c.tabs.favicons.scale = 2.0
c.tabs.max_width = 200
c.tabs.padding = {"bottom": 5, "left": 5, "right": 5, "top": 5}
c.tabs.position = right

with config.pattern("*://github.com") as p:
    p.content.javascript.clipboard = 'access'

c.url.searchengines = {
            "DEFAULT": "https://duckduckgo.com/?q={}",
            "s": "https://sourcegraph.sourcegraph.com/search?q=context:global+{}&patternType=regexp",
            "ss": "https://sourcegraph.com/search?q=context:global+{}&patternType=regexp",
            "g": "https://google.com/search?q={}",
            "gif": "https://giphy.com/search/{}",
         }

def rutorrent():
    import pathlib
    p = pathlib.Path("~/.qutebrowser/.rutorrent").expanduser()
    with open(p) as f:
        creds = f.read()
    return creds.rstrip()

config.bind(',1', "open https://mail.google.com")
config.bind(',2', "open https://calendar.google.com")
config.bind(',3', "open https://github.com")
config.bind(',4', "open https://sourcegraph.sourcegraph.com")
config.bind(',5', "open https://sourcegraph.com")
config.bind(',6', "open https://sourcegraph.test:3443")
config.bind(',7', f"open https://{rutorrent()}@leon.feralhosting.com/burmudar/rutorrent/")
config.bind('tt', 'set-cmd-text -s :tab-select')
