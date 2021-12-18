# general
alias h='cd $HOME'
alias pass=gopass
alias aenv='source $(fd -s "activate")'
alias denv='deactivate'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'


if [[ $OSTYPE == "darwin"* ]]; then
	alias ls='ls -G'
	alias cat='batcat'
else
	alias ls='ls --color=auto'
	alias cat='batcat'
fi
