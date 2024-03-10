#!/usr/bin/env bash

PACKS=(
    visual-studio-code-bin # duh
    1password # for password management
    1password-cli # for password management in the terminal
    git-credential-1password # for password management in git
    cronie # for scheduled tasks
    borg # for backups
    timeshift # for system snapshots
    timeshift-autosnap # for automatic system snapshots
    grub-btrfs # for grub support for btrfs
    detox # for file renaming
    zotero # for reference management
    spotify # for music
    obsidian # for note taking
    libreoffice-fresh # for office stuff
    texlive # for latex
    biber # for biblatex
    pandoc # for document conversion
    firefox # for browsing
    inkscape # for vector graphics
    gimp # for raster graphics
    darktable # for photo editing
    vlc # for media
    pyenv # for python version management
    pyenv-virtualenv # for python virtualenv management
    python-poetry # for python package management
    kitty # for a better terminal
    ufw # for firewall
    diff-so-fancy # nicer git diff view
)

echo "Installing workspace utilities"
paru -S --noconfirm --needed ${PACKS[@]}

# Enable firewall
echo "Enabling firewall"
sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo systemctl enable ufw
sudo ufw enable
sudo ufw status verbose

# Enable cronie so that scheduled timeshift snapshots are actually executed
systemctl enable cronie.service
systemctl start cronie.service
