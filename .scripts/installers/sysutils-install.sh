#!/usr/bin/env bash

PACKS=(
    exa
    git
    bat
    ripgrep
    tldr
    man-db
    most
    openssh
    rsync
    tlp
    ntfs-3g
    exfatprogs
    sshfs
    alacritty
    python-pip
    neovim
    npm # for some neovim plugins
    tmux
    glib2 # for trashing files in the terminal
    zsh
    starship
    zsh-syntax-highlighting-git
    zsh-autosuggestions-git
    zsh-autocomplete-git
    neofetch
    cmatrix-git
    pyenv 
    pyenv-virtualenv
)

paru -S --needed --noconfirm ${PACKS[@]}

# Add some config to tlp
sudo rm -f /etc/tlp.d/10-my.conf
sudo touch /etc/tlp.d/10-my.conf
sudo tee -a /etc/tlp.d/10-my.conf > /dev/null <<EOT
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_ENERGY_PERF_POLICY_ON_AC=performance
CPU_ENERGY_PERF_POLICY_ON_BAT=balance_power
CPU_MIN_PERF_ON_AC=0
CPU_MAX_PERF_ON_AC=100
CPU_MIN_PERF_ON_BAT=0
CPU_MAX_PERF_ON_BAT=75
CPU_BOOST_ON_AC=1
CPU_BOOST_ON_BAT=1
CPU_HWP_DYN_BOOST_ON_AC=1
CPU_HWP_DYN_BOOST_ON_BAT=0
USB_EXCLUDE_PHONE=1
EOT

# diable the annoying loud beep sound
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf
