export no_proxy=".oraclecorp.com,.oracle.com,.nimbula.org,localhost,127.0.0.1"
export NO_PROXY=".oraclecorp.com,.oracle.com,.nimbula.org,localhost,127.0.0.1"

uproxies () {
    unset PROXY_ENV
    unset http_proxy
    unset https_proxy
    unset HTTP_PROXY
    unset HTTPS_PROXY
}

proxies () {
    export PROXY_ENV="📡"
    export http_proxy=http://www-proxy-lon.uk.oracle.com:80
    export https_proxy=http://www-proxy-lon.uk.oracle.com:80
    export HTTP_PROXY=http://www-proxy-lon.uk.oracle.com:80
    export HTTPS_PROXY=http://www-proxy-lon.uk.oracle.com:80
}

oyubi () {
    _ensure_ssh_agent_running
    local AUTH_SOCK=$(env | grep SSH_AUTH_SOCK | sed s/SSH_AUTH_SOCK=//)
    local AGENT_PID=$(env | grep SSH_AGENT_PID | sed s/SSH_AGENT_PID=//)

    eval `SSH_AGENT_PID=${AGENT_PID} SSH_AUTH_SOCK="${AUTH_SOCK}" ssh-add -s /usr/local/lib/opensc-pkcs11.so`
}

oenv () {
    local RESULT="$(cat ~/.oci/tenancies | fzf --height 5)"
    export TENANCY_NAME="$(echo ${RESULT} | cut -d ':' -f 1)"
    export COMPARTMENT_ID=$(echo ${RESULT} | awk -F '"' '{ print $2 }')
    export REGION="$(cat ~/.oci/regions | fzf --height 12)"
    ostatus
}

ostatus ()  {
    local bold=$(tput bold)
    local normal=$(tput sgr0)
    echo "${normal}Tenancy:${bold} ${TENANCY_NAME} ${normal}Region:${bold} ${REGION}${normal}"
}

ossh () {
    local host=$(grep -h -i -E "Host [[:alnum:]_\-]+$" ~/.ssh/ams-configs/*.config | awk '{print $2;}' | fzf)
    echo "ssh to host: ${host}"
    ssh ${host}
}

unoenv() {
    unset COMPARTMENT_ID
    unset REGION
}

cond_source $HOME/.sdkman/bin/sdkman-init.sh
