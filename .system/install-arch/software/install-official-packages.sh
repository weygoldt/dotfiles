#!/bin/bash

cd # change dir to home

# package list
PACKAGES=(
        torbrowser-launcher     # for anonymous browsing
        torsocks                # for torified shell
        keepassxc               # for encrypted harddrives
        veracrypt               # to encrypt harddrives
        libreoffice             # for university stuff
        texlive-most            # to write nice theses
        biber                   # better tex citation backend
        pandoc                  # document converter
        firefox                 # standard browser
        inkscape                # vector editor
        gimp                    # gnu image manipulation program
        vlc                     # media player
        ufw                     # firewall
        zsh                     # better shell than bash
        neofetch                # for quick system overview
        tk                      # Some python gui lib (was dependency for something?)
        r                       # statistical computing
        arduino                 # arduino IDE
        conky                   # best system monitor
        ncdu                    # disk usage overview
        cronie                  # from cronjobs (e.g. timeshift)
        python-pip              # to manage python modules
        bashtop                 # system monitor
        ifuse                   # below all for IPhone support
        usbmuxd
        libplist
        libimobiledevice
        obsidian                # personal knowledge management
        obs-studio              # screen recording
        neovim                  # text editor
        tmux                    # terminal multiplexer
)

# install package list
sudo pacman -S --noconfirm ${PACKAGES[@]}

# Enable firewall
sudo systemctl enable ufw
sudo ufw enable

# Change default shell to zsh (also did not execute for some reason)
sudo chsh -s /usr/bin/zsh

# Enable cronie so that scheduled timeshift snapshots are actually executed
systemctl enable cronie.service
systemctl start cronie.service
