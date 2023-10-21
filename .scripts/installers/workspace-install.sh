#!/usr/bin/env bash

printf "\e[1;32m WARNING Installing miniconda requires user input!\e[0m"

PACKS=(
    visual-studio-code-bin
    # lunarvim-git
    espanso-git
    1password
    1password-cli
    git-credential-1password
    cronie
    borg 
    unison
    timeshift
    timeshift-autosnap
    grub-btrfs
    # btrbk
    detox
    zotero
    # anki
    # zoom
    spotify
    obsidian
    onlyoffice-bin
    texlive
    biber
    pandoc
    firefox
    inkscape
    gimp
    darktable
    # digikam
    # davinci-resolve
    vlc
    arduino
    pyenv
    pyenv-virtualenv
    python-poetry
    alacritty
    kitty
    ufw
    # python-ruff
    # kwin-bismuth
)

paru -S --noconfirm --needed ${PACKS[@]}

# Enable firewall
# sudo ufw limit 22/tcp
# sudo ufw allow 80/tcp
# sudo ufw allow 443/tcp
# sudo ufw default deny incoming
# sudo ufw default allow outgoing
sudo systemctl enable ufw
sudo ufw enable

# Enable cronie so that scheduled timeshift snapshots are actually executed
systemctl enable cronie.service
systemctl start cronie.service

# download latest miniconda for linux
# cd ~
# wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

# # execute install script
# zsh ./Miniconda3-latest-Linux-x86_64.sh
