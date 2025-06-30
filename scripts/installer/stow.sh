#!/usr/bin/env bash

# assume dotfiles is in $HOME/dev

# stow zsh configuration
stow --dir "$HOME"/dev/dotfiles/ --target "$HOME" zsh --verbose

# stow nvim configuration
stow --dir "$HOME"/dev/dotfiles/ --target "$HOME" nvim --verbose

stow --dir "$HOME"/dev/dotfiles/ --target "$HOME" bin --verbose
