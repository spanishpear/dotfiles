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
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="dd.mm.yyyy"

plugins=(
 fnm
 git
 fzf
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
wt() {
    if [[ "$1" == "switch" ]]; then
        dir=$(auto-worktree "$@" | grep -v "^\s*$" | grep "/" | tail -n1 | sed 's/\x1B\[[0-9;]*[a-zA-Z]//g' | tr -d '\n')
        local exit_status=$?
        if [[ $exit_status -eq 0 && -d "$dir" ]]; then
            cd "$dir"
        fi
    else
        auto-worktree "$@"
    fi
}

# $1 is the branch name
# $2 is the remote name
git-fetch-and-checkout-from-origin() {
  set +x
  local branch
  local remote

  branch=$1
  remote="origin"


 # check if any changes on local
 if [[ -n $(git status -s) ]]; then
   echo "You have changes on local. Please commit or stash them first."
   return 1
 fi

 git fetch $remote $branch || return 1
 git checkout $branch || return 1
 set -x
}


# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="micro ~/.zshrc"
alias zshrc="nvim $ZDOTDIR/.zshrc && source $ZDOTDIR/.zshrc "
alias nvimrc="cd $HOME/.config/nvim/ && nvim init.lua && cd -"
alias ohmyzsh="code ~/.oh-my-zsh"
alias lazygit="lazygit --use-config-file='$HOME/.config/lazygit/config.yml'"
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
alias cr="cargo run"

export TERM=xterm-256color
fpath+=${ZDOTDIR:-~}/.zsh_functions

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
export PATH=$PATH:"/opt/X11/bin":"$HOME/.local/bin:$HOME/.fzf/bin:$HOME/.cargo/bin:$HOME/bin:$HOME/.jenv/bin:$JAVA_HOME/bin"

# better zsh histroy
export HISTFILE=~/.zsh_history
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
export HISTTIMEFORMAT="[%F %T] "
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE

# other variables
export NVIM="$HOME/.config/nvim"
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
 [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export GPG_TTY=`tty`

# https://github.com/nodejs/node/issues/52229
export CXXFLAGS='-DNODE_API_EXPERIMENTAL_NOGC_ENV_OPT_OUT'

if [[ -f $ZDOTDIR/.zshrc-$HOST ]]; then
   [[ ! -f $ZDOTDIR/.zshrc-$HOST.zwc || $ZDOTDIR/.zshrc-$HOST -nt $ZDOTDIR/.zshrc-$HOST.zwc ]] && { zcompile $ZDOTDIR/.zshrc-$HOST;}
   source $ZDOTDIR/.zshrc-$HOST
fi


# vim: set ft=zsh:

# pnpm
export PNPM_HOME="/Users/ssomaiya/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
