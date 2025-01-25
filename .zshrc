# Add deno completions to search path
if [[ ":$FPATH:" != *":/home/shrey/.zsh/completions:"* ]]; then export FPATH="/home/shrey/.zsh/completions:$FPATH"; fi
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

ZSH_THEME="powerlevel10k/powerlevel10k"
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
 fnm
 git 
 fzf 
 node 
 zsh-syntax-highlighting 
 zsh-autosuggestions 
 yarn
 z
)
 
source $ZSH/oh-my-zsh.sh

export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export EDITOR='nvim'
export SSH_KEY_PATH="~/.ssh/rsa_id"

fzf-git-checkout() {
    git branch | grep -v "^\*" | fzf --height=20% --reverse --info=inline | xargs git checkout
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
alias ls="eza"
alias ll="eza -l"
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
alias cr="cargo run"

PATH=/opt/homebrew/bin:/opt/atlassian/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
export PATH=$PATH:"/opt/X11/bin":"$HOME/.local/bin:$HOME/.fzf/bin:$HOME/.cargo/bin:$HOME/bin:$HOME/.jenv/bin:/opt/homebrew/opt/util-linux/bin:$JAVA_HOME/bin"

export NVIM="$HOME/.config/nvim"
export TERM=xterm-256color
fpath+=${ZDOTDIR:-~}/.zsh_functions

# todo - move this to osx.zsh
if [ -f $HOME/.stash_token ]; then
    source $HOME/.stash_token
fi

if [ -f $HOME/.bbc_token ]; then
    source $HOME/.bbc_token
fi

if [ -f $HOME/.afm-git-configrc ]; then
    source $HOME/.afm-git-configrc
fi

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


if which jenv > /dev/null; then eval "$(jenv init -)"; fi

export GPG_TTY=$(tty)
export CXXFLAGS='-DNODE_API_EXPERIMENTAL_NOGC_ENV_OPT_OUT'

export PATH="$HOME/.local/bin:$PATH"

if [[ -f ~/.zshrc-$HOST ]]; then
   [[ ! -f ~/.zshrc-$HOST.zwc || ~/.zshrc-$HOST -nt ~/.zshrc-$HOST.zwc ]] && { zcompile ~/.zshrc-$HOST;}
   source ~/.zshrc-$HOST
fi

. "/home/shrey/.deno/env"