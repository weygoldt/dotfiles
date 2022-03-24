#!/bin/sh
# Description: Synchronizes two directories.

# Prints the directories that will be updated in the destination using rsync dryrun...

# Then synchronizes the directories without information about permissions,
# groups and owners of the directories (would cause rsync difficulties 
# between btrfs and ntfs / exFAT /etc. filesystems) ...

# Then shows the new differences between the directories (which should be none) using a second call of rsync dryrun with the same switches.

# Directories for synchronization.
SOURCEDIR='/home/weygoldt/'                    # Source of the files to back up
SINKDIR='/mnt/databackup/home-backup/'         # Destination of backup

echo # to make a new line
printf "\e[1;32mThe following files will be synchronized:\e[0m"
echo # to make a new line
echo # to make a new line
sleep 3s

# print differences
# not using -a to prevent permissions, groups and owners to be transferred between case-sensitive 
# and case-insensitive filesystems. This would prevent rsync from allawys synchronizing all. 
# All other switches included in -a are active.
rsync -rltzviPn --delete --delete-excluded --exclude='.cache/*' "$SOURCEDIR" "$SINKDIR"

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
        rsync -rltzviP --delete --delete-excluded --exclude={'.cache/*'} "$SOURCEDIR" "$SINKDIR"
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
rsync -rltzviPn --delete --delete-excluded --exclude='.cache/*' "$SOURCEDIR" "$SINKDIR"
