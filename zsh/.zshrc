# https://github.com/zplug/zplug
source ~/.zplug/init.zsh
source ~/.zwilliam



zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting"

if ! zplug check --verbose; then
	printf "Install ? [yN]: "
	if read -q; then
		echo; zplug install
	fi
fi

zplug load
