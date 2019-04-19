# https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins-Overview

export RC=${HOME}/dotfiles

export ZSH=${RC}/.oh-my-zsh

ENABLE_CORRECTION="false"
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
  )

source $ZSH/oh-my-zsh.sh

#source *.zsh
for rcfile in ${RC}/.rc/zsh/**.zsh; do
  source $rcfile;
done
