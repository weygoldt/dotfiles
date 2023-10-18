#!/bin/bash

if hash btrbk  2>/dev/null; then
    echo $'\e[1;32mCreating btrbk snapshot ...\e[0m'
    echo
    sudo btrbk clean --progress --pretty
fi

if hash timeshift  2>/dev/null; then
    echo $'\e[1;32mCreating timeshift snapshot ...\e[0m'
    echo
    sudo timeshift --create --comments "Snapshot created by cleaner.sh"
fi

echo $'\e[1;32mCleaning system journal ...\e[0m'
sudo journalctl --vacuum-time=2weeks

echo $'\e[1;32mCleaning package cache ...\e[0m'
echo
paru -Sc

echo $'\e[1;32mRemoving orphaned packages ...\e[0m'
echo
paru --clean

echo $'\e[1;32mCleaning home cache ...\e[0m'
rm -rf $HOME/.cache/*

echo $'\e[1;32mDeleting downloads ...\e[0m'
rm -rf $HOME/Downloads/*

echo $'\e[1;32mRebooting ...\e[0m'
sleep 2s
sudo reboot
