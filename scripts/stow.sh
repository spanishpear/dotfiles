#!/usr/bin/env bash

# append export zdotdir to .zshenv
echo "export ZDOTDIR=$HOME/.config/zsh" >>"$HOME"/.zshenv

# stow zsh configuration
stow --dir "$HOME"/dev/dotfiles/ --target "$HOME" zsh --verbose

# stow nvim configuration
stow --dir "$HOME"/dev/dotfiles/ --target "$HOME" nvim --verbose
