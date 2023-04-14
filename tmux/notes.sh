#!/bin/bash
NAME="journal"
CMD="zk new --no-input -g journal"
win_idx=$(tmux list-windows -F '#I #W' | awk "\$2 ~ /$NAME/ { print \$1 }" | head -n 1)

if [[ -z $win_idx ]]; then
    win_idx=$(tmux new-window -n $NAME -d -P -F "#I")
fi

session=$(tmux display-message -p '#S')
target="$session:$win_idx"

curr_win=$(tmux display-message -p '#I')
current="$session:$curr_win"


if [[ "$target" == "$current" ]]; then
    tmux last-window
else
    tmux send -t $target "$CMD" C-m
    tmux select-window -t $target
fi
