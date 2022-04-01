#!/bin/bash
NAME="password"
win_idx=$(tmux list-windows -F '#I #W' | awk "\$2 ~ /$NAME/ { print \$1 }" | head -n 1)

if [[ -z $win_idx ]]; then
    win_idx=$(tmux new-window -n $NAME -d -P -F "#I")
fi

session=$(tmux display-message -p '#S')

target="$session:$win_idx"
tmux send -t $target "lpass" C-m
tmux select-window -t $target
