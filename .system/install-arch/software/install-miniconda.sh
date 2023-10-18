#!/bin/bash
# install miniconda

# message
printf "\e[1;32mInstalling miniconda requires user input!\e[0m"

# download latest miniconda for linux
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

# execute install script
zsh ./Miniconda3-latest-Linux-x86_64.sh