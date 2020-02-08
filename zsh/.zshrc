# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/usr/share/oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster-time"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git cp extract autojump)


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

ZSH_CACHE_DIR=$HOME/.oh-my-zsh-cache
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh
alias l='ls -lah  --time-style="+%Y %m-%d %H:%M:%S "'
alias l.='ls -ladh  --time-style="+%Y %m-%d %H:%M:%S " .*'
alias ll='ls -lh  --time-style="+%Y %m-%d %H:%M:%S "'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias jobs='jobs -l'
alias psa='ps axo stat,euid,ruid,tty,tpgid,sess,pgrp,ppid,pid,pcpu,pmem,comm'
alias pstree='pstree -Uup'
alias free='free -wh'
alias vmstat='vmstat -w'
alias ip='ip -c'
alias tmuxn='tmux new -s'
alias tmuxa='tmux a'
alias expactf='expac --timefmt="%Y-%m-%d %T" "%l\t%n" | sort'
# zsh中git插件的补充
alias gmv='git mv'
alias grst='git restore --staged'
alias gdtre='git diff-tree'
alias gdt='git difftool --tool=gvimdiff3'
alias gdts='git difftool --staged --tool=gvimdiff3'
alias gmt='git difftool --staged --tool=gvimdiff3'
alias gt='git tag'
alias gta='git tag -a'
alias gtd='git tag -d'
alias gbav='git branch -a -vv'
alias glr='git ls-remote'
alias gpd='git push -d'
alias gpt='git push --tags'

function seec() {
    if [[ -n "$1" && "$1" == "-l" ]] ;then
	grep -i ● ~/.cheat/Linux.note
	return $?
    fi
    sed -n "/●.*$1/,/^$/p" ~/.cheat/Linux.note
}

function seep() {
    if [[ -n "$1" && "$1" == "-l" ]] ;then
	grep -i ○ ~/.cheat/Linux.note
	return $?
    fi
    sed -n "/○.*$1/,/^$/p" ~/.cheat/Linux.note
}

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

#为gvim中自定义的Quick_C_R函数执行，若在gvimrc中执行会导致gvim崩溃
if [ ! -e /tmp/AsyncRun/TMPFILES ] ;then
    mkdir -p /tmp/AsyncRun/TMPFILES
fi
