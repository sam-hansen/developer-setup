#!/bin/bash
#########################################
#|:==== My Development Environment====:|#
#|:       Complete w/ Dotfiles        :|#
#|:           by Sam Hansen           :|#
#|:     Email: sam.hans24@yahoo.com   :|#
#|:-----------------------------------:|#
#########################################
# Linux desktop only: install terminal from https://hyper.is/#installation
# wget https://releases.hyper.is/download/AppImage

HOME=/home/sam
RC=$HOME/dotfiles/.rc

# Apt/Package Manager Installs
sudo apt update && sudo apt install -y  \
    zsh wget automake curl git xclip    \
    trash-cli zsh-syntax-highlighting   \
    python3-pip

# Oh-My-Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install Oh-My-ZSH
echo "Installing Oh-My-ZSH..."
git clone git://github.com/robbyrussell/oh-my-zsh.git ${RC}/.oh-my-zsh;
echo "Install plugins for ZSH..."
git clone https://github.com/zsh-users/zsh-history-substring-search \
    ${ZSH_CUSTOM}/plugins/zsh-history-substring-search;
git clone https://github.com/gretzky/auto-color-ls \
    ${ZSH_CUSTOM}/plugins/auto-color-ls;
git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM}/plugins/zsh-autosuggestions;
git clone https://github.com/zpm-zsh/colors \
    ${ZSH_CUSTOM}/plugins/colors;
git clone https://github.com/zpm-zsh/colorize \
    ${ZSH_CUSTOM}/plugins/colorize

echo "plugins=(auto-color-ls autojump base16-shell extract git sudo themes urltools z zsh-256color zsh-history-substring-search zsh_reload zsh-navigation-tools zsh-syntax-highlighting)" \
    | tee ~/.zshrc

# install unix tools
sudo apt install  -y silversearcher-ag ranger git fonts-roboto;
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

# backup
cd ${HOME} && mv .zshrc .zshrc.old && mv ${HOME}/.config/Hyper/.hyper.js ${HOME}/.config/Hyper/.hyper.js.old

# overwrite rc
ln -s ${RC}/zsh/.zshrc ${HOME}/.zshrc
ln -s ${RC}/hyper/.hyper.js ${HOME}/.config/Hyper/.hyper.js

mkdir ~/bin ~/devenv ~/.dev ~/.fndir ~/.gists ~/.icons ~/myrepos ~/projects ~/.repos ~/sources ~/.themes ~/tmp

# Micro
curl https://getmic.ro | bash ;
mv ~/micro ~/bin/micro ;
# Alternatively use snap
# sudo snap install micro --classic 

# Node
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash - ;
sudo apt-get install -y nodejs ;
# Optional: install build tools
sudo apt-get install -y build-essential ;

# Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -\
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn ;
echo "export PATH='$PATH:/opt/yarn-1.3.2/bin'" | tee $HOME/.zshrc ;
echo "export PATH="$PATH:`yarn global bin`"" | tee $HOME/.zshrc ;
# Empty Trash
cd ~/.dev && sudo npm i -g empty-trash-cli ;

# Powerlevel9k Themeing
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k ;

# Powerline Fonts w/ package-managers
sudo apt-get install fonts-powerline ;
sudo pip3 install powerline-status ;
# Powerline manually installed
git clone https://github.com/powerline/fonts.git ;
cd fonts && ./install.sh ;
wget https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf \
wget https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf ;
mv PowerlineSymbols.otf ~/.local/share/fonts/ ;
fc-cache -vf ~/.local/share/fonts/ ;
mv 10-powerline-symbols.conf ~/.config/fontconfig/conf.d/ ;

# Adding Elvish Shell!
# Add Elvish PPA repo
sudo wget -O /etc/apt/trusted.gpg.d/elvish \
  'https://sks-keyservers.net/pks/lookup?search=0xE9EA75D542E35A20&options=mr&op=get';
sudo gpg --dearmor /etc/apt/trusted.gpg.d/elvish;
sudo rm /etc/apt/trusted.gpg.d/elvish;
echo 'deb http://ppa.launchpad.net/zhsj/elvish/ubuntu xenial main' | sudo tee /etc/apt/sources.list.d/elvish.list;
sudo apt-get update
# Install Elvish
sudo apt-get install elvish

