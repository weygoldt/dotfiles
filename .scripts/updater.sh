#!/bin/sh

# create btrbk snapshot if btrbk is installed
if hash btrbk  2>/dev/null; then
    echo $'\e[1;32mCreating btrbk snapshot ...\e[0m'
    echo
    sudo btrbk clean --progress --pretty
fi

# create timeshift snapshot if timeshift is installed
if hash timeshift  2>/dev/null; then
  # check if timeshift is configured to create snapshots automatically
  if hash timeshift-autosnap  2>/dev/null; then
    echo
  else
    echo $'\e[1;32mCreating timeshift snapshot ...\e[0m'
    echo
    sudo timeshift --create --comments "Snapshot created by updater.sh"
  fi
fi

echo $'\e[1;32mRefreshing mirrors ...\e[0m'
sudo systemctl start reflector.service

echo $'\e[1;32mUpdating system ...\e[0m'
paru -Syu

echo $'\e[1;32mConda\e[0m'
conda update -n base -c defaults conda

echo $'\e[1;32mDeleting uninstalled packages from cache ...\e[0m'
sudo pacman -Sc
paru -Sc
paru --clean 
