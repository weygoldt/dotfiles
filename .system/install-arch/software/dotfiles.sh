#!/bin/bash
# A script to install my most used dotfiles on a new linux system.

cd # change dir to home

# append alias to .zshrc. Remove comment for new .zshrc
# echo 'alias dfs="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"' >> $HOME/.zshrc

# source new .zshrc
source ~/.zshrc

# add dotfiles repo to gitignore
echo ".dotfiles" >> .gitignore

# clone bare repository to home
git clone --bare https://github.com/weygoldt/dotfiles.git $HOME/.dotfiles

# create dotfiles in home dir
dfs checkout

# hide untracked files warnings 
dfs config --local status.showUntrackedFiles no