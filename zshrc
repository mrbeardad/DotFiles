alias l='ls -lah  --time-style="+%Y %m-%d %H:%M:%S "'
alias l.='ls -ladh  --time-style="+%Y %m-%d %H:%M:%S " .*'
alias ll='ls -lh  --time-style="+%Y %m-%d %H:%M:%S "'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias jobs='jobs -l'
alias pstree='pstree -Uup'
alias free='free -wh'
alias vmstat='vmstat -w'
alias ip='ip -c'
alias tmuxn='tmux new -s routin'
alias tmuxa='tmux a'
alias expactf='expac --timefmt="%Y-%m-%d %T" "%l\t%n" | sort'
# zsh中git插件的补充
alias gmv='git mv'
alias grst='git restore --staged'
alias gdtre='git diff-tree'
alias gdt='git difftool --tool=gvimdiff3'
alias gdts='git difftool --staged --tool=gvimdiff3'
alias gt='git tag'
alias gta='git tag -a'
alias gtd='git tag -d'
alias gbav='git branch -a -vv'
alias glr='git ls-remote'
alias gpd='git push -d'
alias gpt='git push --tags'
function man() {
        LESS_TERMCAP_md=$'\e[01;34m' \
	LESS_TERMCAP_me=$'\e[0m' \
	LESS_TERMCAP_se=$'\e[0m' \
	LESS_TERMCAP_so=$'\e[01;46;30m' \
	LESS_TERMCAP_ue=$'\e[0m' \
	LESS_TERMCAP_us=$'\e[01;32m' \
	command man "$@"
}

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
