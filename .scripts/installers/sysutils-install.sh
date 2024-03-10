#!/usr/bin/env bash

PACKS=(
    exa # for better ls
    git # for version control
    bat # for better cat
    zoxide # for better directory navigation
    fzf # for fuzzy finding
    ripgrep # for better grep
    tldr # for even shorter manpages
    man-db # also some kind of man pager?
    most # for a better man pager
    openssh # for ssh
    rsync # for file syncing
    tlp # for power management
    ntfs-3g # for ntfs support
    exfatprogs # for exfat support
    sshfs # for mounting remote filesystems
    kitty # for a better terminal
    python-pip # for python package management
    neovim # for a better text editor
    npm # for some neovim plugins
    tmux # for terminal multiplexing
    glib2 # for trashing files in the terminal
    zsh # for a better shell
    starship # for a nice prompt
    zsh-syntax-highlighting-git # for zsh syntax highlighting
    zsh-autosuggestions-git # for zsh autocompletion
    zsh-autocomplete-git # for zsh autocompletion
    neofetch # for fun
    cmatrix-git # for fun
    pyenv # for python version management
    pyenv-virtualenv # for python virtualenv management
)

echo "Installing system utilities"
paru -S --needed --noconfirm ${PACKS[@]}

# diable the annoying loud beep sound
echo "Disabling the annoying beep sound"
echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf

# Add some config to tlp
# But ask for it first so we can skip it if we want
read -p "Do you want to add some custom tlp config? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Adding custom tlp config"
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
fi
if [[ $REPLY =~ ^[Nn]$ ]]
then
    echo "Skipping tlp config"
fi
