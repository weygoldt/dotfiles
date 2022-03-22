#!/bin/sh
# Synchronizes the data folder with the internat backup drive.
rsync -rltzviP --delete /home/weygoldt/Data/ /mnt/databackup/databackup
