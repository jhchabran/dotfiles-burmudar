# general
alias h='cd $HOME'
alias pass=gopass
alias aenv='source $(fd -s "activate")'
alias denv='deactivate'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias cat='bat'


if [[ $OSTYPE == "darwin"* ]]; then
	alias ls='ls -G'
else
	alias ls='ls --color=auto'
fi
