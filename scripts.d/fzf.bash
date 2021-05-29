
# List projects
lp () {
    project=$(fd . "${SRC}" -t d -d 1 | awk -F '/' '{ print $5}' | fzf --prompt 'project>' -1 -0 --height=10 --ansi --preview='cd $SRC/{} && git log --oneline')

    if [ -n "${project}" ]; then
        cd $SRC/${project}
    fi
}
