
# gb - checkout git branch
unalias gb 2>/dev/null
unalias gbr 2>/dev/null
gb () {
  branches=$(git --no-pager branch -vv) &&
  branch=$(echo "$branches" | fzf +m --height=15) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# gbr - checkout git branch (including remote branches)
gbr () {
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

gnb () {
    local branch_name=$1
    git switch -c $branch_name
}
