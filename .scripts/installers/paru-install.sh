#!/usr/bin/env bash

cd ~
sudo pacman -S --needed --noconfirm git
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
