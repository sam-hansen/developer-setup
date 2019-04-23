#!/bin/zsh
# My ZSH Configs
export HOME=/home/sam
export RC=${HOME}/dotfiles/.rc
export ZSH=${RC}/.oh-my-zsh

# Oh-My-ZSH Conifgs
ENABLE_CORRECTION="true"

# https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins-Overview
plugins=(
  git-extras
  npm
  dirhistory
  common-aliases
  zsh-syntax-highlighting
  extract
  cp
  copyfile
  zsh-history-substring-search
  sudo
  themes
)

source $ZSH/oh-my-zsh.sh

# source *.zsh
for rcfile in ${RC}/.rc/zsh/**.zsh; do
  source $rcfile;
done
