#!/bin/sh
sourcedir='/home/weygoldt/Data/'
sinkdir='/run/media/weygoldt/Extreme SSD/patrick/'
sinkdevice='/run/media/weygoldt/Extreme SSD'

# syncfunction
syncdirs () { 
   rsync -avzP --delete --info=progress2 "$sourcedir" "$sinkdir"
}

# dismountfunction
dismountdevice () {
    umount "$sinkdevice"
}

printf "\e[1;32mThe following files will be synchronized:\e[0m"
echo # to make a new line
echo # to make a new line
sleep 3s

# print differences
rsync -avzPn --delete "$sourcedir" "$sinkdir"

echo # to make a new line
echo # to make a new line

while true
do
    read -r -p $'\e[1;32mReview the differences. Do you want to continue (y/n)?\e[0m' choice
    case "$choice" in
      [nN][oO]|[nN]) 
        echo "No"
        break;;
      [yY][eE][sS]|[yY]) 
        syncdirs
        break;;
      *) echo 'Response not valid';;
    esac
done

printf "\e[1;32mSynchronization complete. The new differences are:\e[0m"
echo # to make a new line
echo # to make a new line
sleep 3s

# print new differences
rsync -avzPn --delete "$sourcedir" "$sinkdir"
echo # to make a new line
echo # to make a new line

# dismount drive?
while true
do
    read -r -p $'\e[1;32mDismount the harddrive (y/n)?\e[0m' choice
    case "$choice" in
      [nN][oO]|[nN]) 
        echo "No"
        break;;
      [yY][eE][sS]|[yY]) 
        dismountdevice
        break;;
      *) echo 'Response not valid';;
    esac
done