
# List projects
lp () {
    FZF_ARGS=(--prompt 'project>' -1 -0 --height=10 --ansi --preview='cd $SRC/{} && git log --oneline')

    # if we have a query string, start with it
    if [ -n "${1}" ]; then
        FZF_ARGS+=( -q ${1} )
    fi
    project=$(fd . "${SRC}" -t d -d 1 | awk -F '/' '{ print $5}' | fzf "${FZF_ARGS[@]}")

    if [ -n "${project}" ]; then
        cd $SRC/${project}
    fi
}

lpass () {
    FZF_ARGS=(--prompt 'password>' -1 -0 --height=10 --ansi)
    if [ -n "${1}" ]; then
        FZF_ARGS+=( -q ${1} )
    fi

    key=$(gopass ls -f | fzf "${FZF_ARGS[@]}")
    gopass show -C "${key}"
}
