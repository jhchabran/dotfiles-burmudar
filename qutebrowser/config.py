config.load_autoconfig()

# stop closing things by mistake
config.unbind('d', mode='normal')
config.bind(',d', 'tab-close')

c.input.insert_mode.auto_load = True
c.input.insert_mode.auto_leave = True

with config.pattern("*://github.com") as p:
    p.content.javascript.clipboard = 'access'

c.url.searchengines = {
            "DEFAULT": "https://duckduckgo.com/?q={}",
            "s": "https://sourcegraph.sourcegraph.com/search?q=context:global+{}&patternType=regexp",
            "ss": "https://sourcegraph.com/search?q=context:global+{}&patternType=regexp",
            "g": "https://google.com/search?q={}",
            "gif": "https://giphy.com/search/{}",
         }

config.bind(',1', "open https://mail.google.com")
config.bind(',2', "open https://calendar.google.com")
config.bind(',3', "open https://github.com")

