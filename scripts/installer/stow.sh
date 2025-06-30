#!/usr/bin/env bash

# NOTE - we stow individual - but you could just do `stow .` in $HOME/dev/dotfiles
# if you don't care. Should ensure we use a .stow-local-ignore tho, to not stow, e.g. `README.md`
# assume dotfiles is in $HOME/dev

# stow zsh configuration
stow --dir "$HOME"/dev/dotfiles/ --target "$HOME" zsh --verbose

# stow nvim configuration
stow --dir "$HOME"/dev/dotfiles/ --target "$HOME" nvim --verbose

# stow user binaries and scripts, e.g. `auto-worktree`
stow --dir "$HOME"/dev/dotfiles/ --target "$HOME" bin --verbose
