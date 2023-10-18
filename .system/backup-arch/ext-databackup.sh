#!/bin/sh
# Description: Synchronizes two directories between two harddrives.

# This script first checks if the specified harddrive is mounted
# using the UUID of the specified harddrive.

# Then prints the directories that will be updated in the destination using rsync dryrun...

# Then synchronizes the directories without information about permissions,
# groups and owners of the directories (would cause rsync difficulties 
# between btrfs and ntfs / exFAT /etc. filesystems) ...

# Then shows the new differences between the directories (which should be none) using a second call of rsync dryrun with the same switches.

# Then promts to unmount the destination harddrive.

# Directories for synchronization.
SOURCEDIR='/home/weygoldt/Data/'      # Source of the files to back up
DESTDIR='/patrick/'                   # Destination of backup on drive
UUID="167E-D62E"                      # UUID of backup harddrive
EXCLUDE='/home/weygoldt/Data/system/backup-arch/rsync-exclude.txt'

cd "$SOURCEDIR"

echo # to make a new line
echo "Checking if devices are mounted ..." 
echo # to make a new line

if [[ $(findmnt "UUID=$UUID") ]]; then                                # looks for sinkdev in mounted filesystems
    echo $'\e[1;32mDevice mounted. Proceeding ...\e[0m'               # if mounted prints message
else
    echo $'\e[1;31mDevice NOT mounted. Please mount the drive.\e[0m'  # if not mounted prints warning
    exit 1                                                            # and exits
fi

# Get mountpoint from UUID
MNTPNT=$(df | grep "^$(readlink -f /dev/disk/by-uuid/$UUID) " |sed 's/^[^%]*% \+//')

# Create full sink directory by appending the folder in drive to the mountpoint that was obtained from the UUID
SINKDIR="$MNTPNT$DESTDIR"

# Promts for dismounting efishdata.
while true
do
    read -r -p $'\e[1;32mMay I dismount efishdata-local (y/n)?\e[0m' choice
    case "$choice" in
      [nN][oO]|[nN]) 
        echo "No"
        break;;
      [yY][eE][sS]|[yY]) 
        sudo umount /home/weygoldt/Data/uni/efish/efishdata-local
        break;;
      *) echo 'Response not valid';;
    esac
done

sleep 1s

printf "\e[1;32mThe following files will be synchronized:\e[0m"
echo # to make a new line
echo # to make a new line
sleep 1s

# print differences
# not using -a to prevent permissions, groups and owners to be transferred between case-sensitive 
# and case-insensitive filesystems. This would prevent rsync from allawys synchronizing all. 
# All other switches included in -a are active.
rsync -rtzviPn --delete --exclude-from="$EXCLUDE" "$SOURCEDIR" "$SINKDIR"

echo # to make a new line
# print source and sink to confirm the operation
echo "The source directory is   $SOURCEDIR"
echo "The sink directory is     $SINKDIR"
echo # to make a new line

# Loop prompts for confirmation and then executes rsync command or exits the script.
while true
do
    read -r -p $'\e[1;32mReview the differences. Do you want to continue (y/n)?\e[0m' choice
    echo # to make a new line
    case "$choice" in
      [nN][oO]|[nN]) 
        echo "Aborting ..."
        exit 1;;
      [yY][eE][sS]|[yY]) 
        rsync -rtzviP --delete --exclude-from="$EXCLUDE" "$SOURCEDIR" "$SINKDIR"
        break;;
      *) echo 'Response not valid';;
    esac
done

echo # to make a new line
# Print confirmation message
printf "\e[1;32mSynchronization complete. The new differences are:\e[0m"
echo # to make a new line
echo # to make a new line
sleep 3s

# print new differences after synchronization. This should be empty.
rsync -rtzviPn --delete --exclude-from="$EXCLUDE" "$SOURCEDIR" "$SINKDIR"

echo # to make a new line

# Promts for dismounting the drive. 
while true
do
    read -r -p $'\e[1;32mDismount the harddrive (y/n)?\e[0m' choice
    case "$choice" in
      [nN][oO]|[nN]) 
        echo "No"
        break;;
      [yY][eE][sS]|[yY]) 
        umount "UUID=$UUID"
        break;;
      *) echo 'Response not valid';;
    esac
done

# Promts for dismounting efishdata.
while true
do
    read -r -p $'\e[1;32mMay I remount efishdata-local (y/n)?\e[0m' choice
    case "$choice" in
      [nN][oO]|[nN]) 
        echo "No"
        break;;
      [yY][eE][sS]|[yY]) 
        sudo mount -a
        break;;
      *) echo 'Response not valid';;
    esac
done