#!/bin/sh

# Synchronizes the data folder with the internat backup drive.
rsync -azz --delete /home/weygoldt/Data/ /mnt/databackup/databackup
