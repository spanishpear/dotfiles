# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
ZSH_DISABLE_COMPFIX=true
# Path to your oh-my-zsh installation.
export ZSH="/home/shrey/.oh-my-zsh"

# linuxbrew required
export LDFLAGS="-L/home/linuxbrew/.linuxbrew/opt/isl@0.18/lib"
export CPPFLAGS="-I/home/linuxbrew/.linuxbrew/opt/isl@0.18/include"
export PKG_CONFIG_PATH="/home/linuxbrew/.linuxbrew/opt/isl@0.18/lib/pkgconfig"


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
 
 
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
 
ZSH_THEME="powerlevel10k/powerlevel10k"
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"
 
# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"
 
# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"
 
# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13
 
# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"
 
# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"
 
# Uncomment the following line to enable command auto-correction.
#ENABLE_CORRECTION="true"
 
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
# HIST_STAMPS="mm/dd/yyyy"
 
# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
 
# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
 git pip python brew node npm github zsh-syntax-highlighting zsh-autosuggestions git-open git-prompt zsh-z
)
 
source $ZSH/oh-my-zsh.sh
local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
 
# User configuration
 
export MANPATH="/usr/local/man:$MANPATH"
 
# You may need to manually set your language environment
# export LANG=en_US.UTF-8
 
# Preferred editor for local and remote sessions
export EDITOR='micro'
 
# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="micro ~/.zshrc"
alias zshrc="micro ~/.zshrc"
alias bat="batcat"
alias vpn="nordvpn"
alias ohmyzsh="code ~/.oh-my-zsh"
alias p="perl"
alias start="S"
alias transfer="T"
alias ls="exa"
alias ll="exa -l"
alias ns="npm start"
alias clr="clear"
alias G="| grep"
alias L="| less"
alias M="| more"
alias H="| head"
alias gs="git status"
alias glog="git log 2>/dev/null || cat log.out 2>/dev/null"
alias py3="python3"
alias cse="ssh cse"
alias site="ssh site"
alias gcm="git add . && gc -m"
alias gcp='(){ ga . && gc -m $1 && gp;}'
alias ipad='uxplay'
#alias idea='idea &>/dev/null &'                                                                                                       
alias untar="tar -xvf"
alias gcl="git clone"
alias gpl="git pull"
alias powerup=cpupower frequency-set -g performance
alias powerdown=cpupower frequency-set -g ondemand
alias xmon="micro ~/.xmonad/xmonad.hs"
alias xmob="micro ~/.config/xmobar/xmobarrc0 ~/.config/xmobar/xmobarrc1"
alias mkcd='(){ mkdir -p "$@" && cd "$@"; }'
alias outlook='prospect-mail'
alias logout="sudo pkill -u ${USER}"
alias lock="gnome-screensaver-command -l"
# Some tmux-related shell aliases

# Attaches tmux to the last session; creates a new session if none exists.
alias t='tmux attach || tmux new-session'

# Attaches tmux to a session (example: ta portal)
alias ta='tmux attach -t'

# Creates a new session
alias tn='tmux new-session'

# Lists all ongoing sessions
alias tl='tmux list-sessions'
#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[ -f "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env" ] && source "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"
# export http_proxy=127.0.0.1:8080
# export https_proxy=127.0.0.1:8080

test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
export HOMEBREW_GITHUB_API_TOKEN=0312b1dc485d74235941668a84fa77fdf3ea5163

export PROMPT='${ret_status} %{$fg[magenta]%}%c%{$reset_color%} $(git_super_status) %% '
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/shrey/.local/bin:/home/shrey/.fzf/bin:/home/shrey/.cargo/bin
export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$HOME/Tools/idea-IU-201.8538.31/bin:$PATH:$HOME/UxPlay-master/build"
export PATH=~/.npm-global/bin:$PATH
export PATH=$PATH:"/usr/local/go/bin":"$HOME/bin"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export TERM=xterm-256color
fpath+=${ZDOTDIR:-~}/.zsh_functions
