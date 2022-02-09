export no_proxy=".oraclecorp.com,.oracle.com,.nimbula.org,localhost,127.0.0.1"
export NO_PROXY=".oraclecorp.com,.oracle.com,.nimbula.org,localhost,127.0.0.1"

fix_ocna() {
    sudo find /opt/cisco/anyconnect/profile\
        -type f\
        -name '*.xml'\
        -exec xmlstarlet edit -L -N w=http://schemas.xmlsoap.org/encoding/ --update "//w:EnableAutomaticServerSelection" --value 'false' '{}' \;
}

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

    if [[ -a /usr/local/lib/opensc-pkcs11.so ]] then
        lib_path=/usr/local/lib/opensc-pkcs11.so
    elif [[ -a /usr/lib/x86_64-linux-gnu/opensc-pkcs11.so ]] then
        lib_path=/usr/lib/x86_64-linux-gnu/opensc-pkcs11.so
    fi

    eval `SSH_AGENT_PID=${AGENT_PID} SSH_AUTH_SOCK="${AUTH_SOCK}" ssh-add -s $lib_path`
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
    local host=$(grep -h -i -E "Host [[:alnum:]_\-]+$" $SRC/ociccp-ssh-config/*.config | awk '{print $2;}' | fzf)
    echo "ssh to host: ${host}"
    ssh ${host}
}

unoenv() {
    unset COMPARTMENT_ID
    unset REGION
}

ccat() {
    if [[ -z $1 ]] then
        echo "ccat: missing argument"
        return 1
    fi

    if ! command -v pbcopy &> /dev/null; then
        cat $1 | pbcopy
    else
        cat $1 | xclip -selection clipboard
    fi

    echo "$1 copied to clipboard!"
}

cond_source $HOME/.sdkman/bin/sdkman-init.sh
