#!/bin/bash

sudo timedatectl set-ntp true   # enable ntp time syncronization
sudo hwclock --systohc          # set hardware clock to system clock

# set fastest mirror
sudo reflector -c Germany -a 6 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syy

sudo pacman -S --noconfirm xorg sddm plasma # plasma meta

# sudo pacman -S --noconfirm kde-applications # all kde applications
sudo pacman -S --noconfirm ark dolphin dolphin-plugins ffmpegthumbs gwenview qt5-imageformats kdegraphics-thumbnailers kdesdk-thumbnailers kfind alacritty okular partitionmanager spectacle kwalletmanager kcolorpicker kcolorchooser

# get aur helper
cd ~
git clone https://aur.archlinux.org/paru.git
cd paru/
makepkg -si --noconfirm

sudo systemctl enable sddm
/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
reboot
