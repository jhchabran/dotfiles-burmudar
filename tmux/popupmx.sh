#!/bin/bash

width=${2:-80%}
height=${2:-80%}

session=$(tmux display-message -p -F "#{session_name}")
if [[ $session == "popup" ]]; then
    tmux detach
else
    tmux popup -d '#{pane_current_path}' -xC -yC -w$width -h$height -E "tmux attach -t popup || tmux new -s popup"
fi
