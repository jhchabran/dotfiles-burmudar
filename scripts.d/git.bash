
# gb - checkout git branch
unalias gb 2>/dev/null
unalias gbr 2>/dev/null
gf() {
    git pull
}

gp() {
    git push
}

gb() {
# if we have a query string, start with it
if [ -n "${1}" ]; then
    FZF_ARGS+=( -q ${1} )
fi
project=$(fd . "${SRC}" -t d -d 1 | awk -F '/' '{ print $5}' | fzf "${FZF_ARGS[@]}")
  branches=$(git --no-pager branch -vv) &&
  branch=$(echo "$branches" | fzf +m --height=15 "${FZF_ARGS[@]}") &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# gbr - checkout git branch (including remote branches)
gbr() {
  branches=$(git for-each-ref --sort=-committerdate --format='%(committerdate:short) %(refname:short) ' refs/heads/)
  branch=$(echo "$branches" |fzf-tmux +m)
  git checkout $(echo "$branch" | cut -d ' ' -f2)
}

gnb() {
    local branch_name=$1
    git switch -c $branch_name
}
