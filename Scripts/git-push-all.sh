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
    cd /home/weygoldt/Data/projects/arch-install
    git add . && git commit -m "$msg" 
    git push
}

pusharchmaintenance () {
    cd /home/weygoldt/Data/projects/arch-maintenance
    git add . && git commit -m "$msg" 
    git push
}

pushobsidian () {
    cd /home/weygoldt/Data/obsidian-master
    git add . && git commit -m "$msg" 
    git push
}

while true
do
    read -r -p $'\e[1;32m Commit all tracked and push dotfiles (y/n)?\e[0m' choice
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
    read -r -p $'\e[1;32m Commit all and push arch-install (y/n)?\e[0m' choice
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
    read -r -p $'\e[1;32m Commit all and push arch-maintenance (y/n)?\e[0m' choice
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
    read -r -p $'\e[1;32m Commit all and push obsidian (y/n)?\e[0m' choice
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