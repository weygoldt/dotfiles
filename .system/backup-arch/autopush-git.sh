#!/bin/sh
# this script automatically commits and pushes the specified git repos

# get date of execution
current="`date +'%Y-%m-%d %H:%M:%S'`"
msg="Autopush $current"

# Define functions to move to specified direcotires and execute 
# the respective fit commands.
pushdotfiles () {
    cd /home/weygoldt/
    /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME commit -am "$msg"
    /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME push
}

pusharchinstall () {
    cd /home/weygoldt/Data/system/install-arch
    git add . && git commit -m "$msg" 
    git push
}

pusharchmaintenance () {
    cd /home/weygoldt/Data/system/maintain-arch
    git add . && git commit -m "$msg" 
    git push
}

pusharchbackup () {
    cd /home/weygoldt/Data/system/backup-arch
    git add . && git commit -m "$msg"
    git push
}

pushobsidian () {
    cd /home/weygoldt/Data/obsidian-master
    git add . && git commit -m "$msg" 
    git push
}

# add ssh
ssh-add /home/weygoldt/.ssh/id_ed25519 

while true
do
    read -r -p $'\e[1;32mCommit all tracked and push dotfiles (y/n)?\e[0m' choice
    case "$choice" in
      [nN][oO]|[nN]) 
        echo "No"
        break;;
      [yY][eE][sS]|[yY]) 
        pushdotfiles
        break;;
      *) echo 'Response not valid';;
    esac
done

while true
do
    read -r -p $'\e[1;32mCommit all and push arch-install (y/n)?\e[0m' choice
    case "$choice" in
      [nN][oO]|[nN]) 
        echo "No"
        break;;
      [yY][eE][sS]|[yY]) 
        pusharchinstall
        break;;
      *) echo 'Response not valid';;
    esac
done

while true
do
    read -r -p $'\e[1;32mCommit all and push arch-maintenance (y/n)?\e[0m' choice
    case "$choice" in
      [nN][oO]|[nN]) 
        echo "No"
        break;;
      [yY][eE][sS]|[yY]) 
        pusharchmaintenance
        break;;
      *) echo 'Response not valid';;
    esac
done

while true
do
    read -r -p $'\e[1;32mCommit all and push backup-arch (y/n)?\e[0m' choice
    case "$choice" in
      [nN][oO]|[nN]) 
        echo "No"
        break;;
      [yY][eE][sS]|[yY]) 
        pusharchbackup
        break;;
      *) echo 'Response not valid';;
    esac
done

while true
do
    read -r -p $'\e[1;32mCommit all and push obsidian (y/n)?\e[0m' choice
    case "$choice" in
      [nN][oO]|[nN]) 
        echo "No"
        break;;
      [yY][eE][sS]|[yY]) 
        pushobsidian
        break;;
      *) echo 'Response not valid';;
    esac
done
