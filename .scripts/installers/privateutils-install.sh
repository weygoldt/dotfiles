#!/usr/bin/env bash

PACKS=(
    torbrowser
    keepassxc
    veracrypt
    ifuse
    usbmuxd
    libplist
    libimobiledevice
)

paru -S --needed --noconfirm ${PACKS[@]}

mkdir $HOME/mount/iphone
