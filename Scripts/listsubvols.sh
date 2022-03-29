#!/bin/bash

readarray -t btdev < <(sudo btrfs filesystem show | awk '/ path /{print $NF}' )

for i in "${btdev[@]}"; do 

  device="${i}"
  mountpoint=/var/lib/btrfs/tmp/mnt/$(basename "$i")

  [ -d "$mountpoint" ] || mkdir "$mountpoint"

  grep -qs $mountpoint /proc/mounts
  [ $? -ne 0 ] && mount -v "$device" "$mountpoint"

  while read -r subvol; do
    # whatever you want
  done < <(btrfs subvolume list "$mountpoint")

  umount $mountpoint
  rmdir $mountpoint
done
