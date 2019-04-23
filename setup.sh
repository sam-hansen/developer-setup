#!/bin/bash
# My Setup
# desktop only: install terminal from https://hyper.is/#installation
#wget https://releases.hyper.is/download/AppImage

HOME=/home/Sam
RC=$HOME/dotfiles/.rc

# install zsh
sudo apt install -y zsh;
chsh -s /bin/zsh

# install oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ${RC}/.oh-my-zsh;
git clone https://github.com/zsh-users/zsh-history-substring-search ${RC}/.oh-my-zsh/custom/plugins/zsh-history-substring-search

# install unix tools
sudo apt install  -y silversearcher-ag ranger git fonts-roboto;
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

# backup
cd ${HOME} && mv .zshrc .zshrc.old && mv ${HOME}/.config/Hyper/.hyper.js ${HOME}/.config/Hyper/.hyper.js.old

# overwrite rc
ln -s ${RC}/zsh/.zshrc ${HOME}/.zshrc
ln -s ${RC}/hyper/.hyper.js ${HOME}/.config/Hyper/.hyper.js
