#!/bin/bash

# desktop only: install terminal from https://hyper.is/#installation
# wget https://releases.hyper.is/download/AppImage



#install zsh
sudo apt install -y zsh;
chsh -s /bin/zsh

#install oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

git clone https://github.com/zsh-users/zsh-history-substring-search .oh-my-zsh/custom/plugins/zsh-history-substring-search


#install unix tools
sudo apt install  -y silversearcher-ag ranger git fonts-roboto;
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

#backup
cd ~ && mv .zshrc .zshrc.old && mv ~/.config/Hyper/.hyper.js ~/.config/Hyper/.hyper.js.old

#overwrite rc
ln -s ~/.rc/zsh/.zshrc ~/.zshrc
ln -s ~/.rc/hyper/.hyper.js ~/.config/Hyper/.hyper.js
