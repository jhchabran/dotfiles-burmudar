ssh_add_keys_from_folder () {
    KEY_FOLDER=${1:-$HOME/.ssh/keys/}

    if !pgrep ssh-agent > /dev/null; then
        echo "FAILED"
    else
        echo "SUCCESS"
    fi
}

_ensure_ssh_agent_running() {
    if ! pgrep ssh-agent > /dev/null; then
        eval `ssh-agent -s`
    fi
}

load_keys () {
    _ensure_ssh_agent_running
    local FOLDER=${1:-$SSH_KEY_FOLDER}

    local AUTH_SOCK=$(env | grep SSH_AUTH_SOCK | sed s/SSH_AUTH_SOCK=//)
    local AGENT_PID=$(env | grep SSH_AGENT_PID | sed s/SSH_AGENT_PID=//)

    eval `SSH_AUTH_SOCK="${AUTH_SOCK}"`
    eval `SSH_AGENT_PID="${AGENT_PID}"`


    for k in ${FOLDER}/*.pvt
    do
        ssh-add "$k"
    done
}

reload_agent () {
    echo "Killing all instance of ssh-agent"
    pkill -9 -f ssh-agent
    _ensure_ssh_agent_running
}
