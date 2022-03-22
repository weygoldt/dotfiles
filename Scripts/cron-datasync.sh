#!/bin/sh
# Synchronizes the data folder with the internal backup drive.
rsync -rltzviP --delete /home/weygoldt/Data/ /mnt/databackup/databackup
