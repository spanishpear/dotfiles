# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
ZSH_DISABLE_COMPFIX=true
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

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
 git 
 pip 
 python 
 fzf 
 brew 
 node 
 npm 
 zsh-syntax-highlighting 
 zsh-autosuggestions 
 z
)
 
source $ZSH/oh-my-zsh.sh
 
# User configuration
 
export MANPATH="/usr/local/man:$MANPATH"
 
# You may need to manually set your language environment
# export LANG=en_US.UTF-8
 
# Preferred editor for local and remote sessions
export EDITOR='nvim'
 
# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

fzf-git-branch() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    git branch --color=always --all --sort=-committerdate |
        grep -v HEAD |
        fzf --height 50% --ansi --no-multi --preview-window right:65% \
            --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        sed "s/.* //"
}

fzf-git-checkout() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    local branch

    branch=$(fzf-git-branch)
    if [[ "$branch" = "" ]]; then
        echo "No branch selected."
        return
    fi

    # If branch name starts with 'remotes/' then it is a remote branch. By
    # using --track and a remote branch name, it is the same as:
    # git checkout -b branchName --track origin/branchName
    if [[ "$branch" = 'remotes/'* ]]; then
        git checkout --track $branch
    else
        git checkout $branch;
    fi
}



# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="micro ~/.zshrc"
alias zshrc="nvim $HOME/.zshrc && source $HOME/.zshrc "
alias nvimrc="cd $HOME/.config/nvim/ && nvim init.lua && cd -"
alias ohmyzsh="code ~/.oh-my-zsh"
alias ls="exa"
alias ll="exa -l"
alias ns="npm start"
alias gs="git status"
alias glog="git log 2>/dev/null || cat log.out 2>/dev/null"
alias py3="python3"
alias cse="ssh cse"
alias gb='fzf-git-branch'
alias gco='fzf-git-checkout'
alias site="ssh site"
alias gcm="git add . && gc -m"
alias gcp='(){ gaa && gc -m $1 && gp;}'
alias untar="tar -xvf"
alias gcl="git clone"
alias gpl="git pull"
alias mkcd='(){ mkdir -p "$@" && cd "$@"; }'
alias p='(){ git pull origin $(git rev-parse --abbrev-ref HEAD);}'
alias f='(){ git fetch origin $(git rev-parse --abbrev-ref HEAD);}'
alias yd="dev-tooling/cli/bin/run"
alias windows="m1ddc display 1 set input 15; m1ddc display 2 set input 15"
alias mac="m1ddc display 1 set input 17; m1ddc display 2 set input 18"
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
alias cr="cargo run"

PATH=/opt/homebrew/bin:/opt/atlassian/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
export PATH=$PATH:"/opt/X11/bin":"$HOME/.local/bin:$HOME/.fzf/bin:$HOME/.cargo/bin:$HOME/bin:$HOME/.jenv/bin:/opt/homebrew/opt/util-linux/bin:$JAVA_HOME/bin"

export NVIM="$HOME/.config/nvim"
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
export TERM=xterm-256color
fpath+=${ZDOTDIR:-~}/.zsh_functions

source $HOME/.stash_token
source $HOME/.bbc_token
export NVM_DIR=~/.nvm

# better zsh histroy
export HISTFILE=~/.zsh_history
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
export HISTTIMEFORMAT="[%F %T] "
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE


export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
#export LOCAL_PLATFORM_CONSUMPTION=true

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
 [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Automatically start the SSH agent if it's not already running
if [ ! -f /tmp/.ssh-agent ]; then
    ssh-agent > /tmp/.ssh-agent
    source /tmp/.ssh-agent > /dev/null
    ssh-add ~/.ssh/id_rsa > /dev/null
else
    source /tmp/.ssh-agent > /dev/null
fi

source ~/.afm-git-configrc

if which jenv > /dev/null; then eval "$(jenv init -)"; fi

export GPG_TTY=$(tty)
export CXXFLAGS='-DNODE_API_EXPERIMENTAL_NOGC_ENV_OPT_OUT'

# pnpm
export PNPM_HOME="/Users/ssomaiya/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

export PATH="/Users/ssomaiya/.local/bin:$PATH"

# fnm
FNM_PATH="/Users/ssomaiya/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/Users/ssomaiya/Library/Application Support/fnm:$PATH"
  eval "`fnm env --use-on-cd`"
fi
