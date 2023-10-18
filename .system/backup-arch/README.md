# My arch linux system snapshots and backup setup
A collection of useful scripts and notes I use to backup my arch-linux system 
as well as other data.

**Disclaimer:** This was created for personal documentation of my setup to make 
my setup more reproducible. Do not use this as a guide. In addition, this is 
currently very messy and I will update it once I have time.

## Contents
- [My arch linux system snapshots and backup setup](#my-arch-linux-system-snapshots-and-backup-setup)
  - [Contents](#contents)
  - [System snapshots and backups](#system-snapshots-and-backups)
    - [Prerequisites](#prerequisites)
    - [Partitioning](#partitioning)
        - [1. Mount the root of the primary btrfs device.](#1-mount-the-root-of-the-primary-btrfs-device)
        - [2. Create a btrfs partition on the secondary drive.](#2-create-a-btrfs-partition-on-the-secondary-drive)
    - [BTRBK](#btrbk)
      - [1. Setup](#1-setup)
      - [2. Test the setup](#2-test-the-setup)
      - [3. Scheduling snapshots and backups](#3-scheduling-snapshots-and-backups)
    - [Restoring from snapshots or backups](#restoring-from-snapshots-or-backups)
      - [1. Identify subvolume to restore from](#1-identify-subvolume-to-restore-from)
      - [2. Restore backup (under construction)](#2-restore-backup-under-construction)
      - [3. Create read-write subvolume](#3-create-read-write-subvolume)
      - [4. Cleanup](#4-cleanup)
  - [Btrfs filesystem errors](#btrfs-filesystem-errors)
  - [Data backups](#data-backups)
  - [Project backups](#project-backups)

## System snapshots and backups
Takes btrfs snapshots of a root and home btrfs subvolume on the root device and 
backs them up incrementally to a secondary device.

### Prerequisites
- System partition formated as btrfs with two subvolumes, `@` and `@home` mounted at `/` and `/home` respectively (see [install-arch](https://github.com/weygoldt/install-arch)).
- A secondary drive (here `dev/sda`). 
- [btrbk](https://github.com/digint/btrbk)

### Partitioning
##### 1. Mount the root of the primary btrfs device. 
Btrbk needs access to the root directory to create a directory e.g. 
`btrbk-snapshots` where the snapshots are stored next to the two subvolumes 
of the system. In addition to the two subdirectories `@` (system) and `@home` 
(user dirs), which are mounted at startup, we need to mount the root of the 
btrfs partition as well. The root of a btrfs filesystem always has the 
`subvolid=5`, which we can use to mount it.
```sh
sudo mkdir /mnt/archlinux # named after my system partition label
# mount btrfs root partition:
sudo mount -o defaults,subvolid=5 /dev/nvme0n1p2 /mnt/archlinux
``` 
Add the mountpoint to `fstab` and check if successful by `sudo mount -a`. 
The directory `/mnt/archlinux` should now include the two subvolumes `@` 
and `@home`. Alternatively, the mound command could also be included into 
the configuration file later to only mount the root partition when a snapshot 
is performed.

##### 2. Create a btrfs partition on the secondary drive. 
Now we need to set up the secondary internal (or any external) device to receive the backups of the snapshots. I am using `dev/sda`.
```sh
# to wipe the drive
sudo umount /dev/sda
sudo gdisk /dev/sda

# These are needed:
o # to wipe the drive
w # to write the changes
n # for a new partition
```
Set parition size and number according to preferences and use the linux filesystem. My backup partition is `/dev/sda2`. Then make the btrfs file system on the new partition:
```sh
mkfs.btrfs /dev/sda2
```
Now mount the file system and create the subvolumes:
```sh
sudo mkdir /mnt/backup              # make a mntpnt
sudo mount /dev/sda2                # mount
sudo btrfs subvol create @backups   # make backups subvol
sudo btrfs subvol create @data      # also added subvol for other stuff 
```
Then unmount `/dev/sda2` and instead mount the new subvolumes `@backups` and `@data`
```sh
sudo umount /dev/sda2               # unmount
sudo rmdir /mnt/backup              # remove mntpnt created earlier
sudo mkdir /mnt{backups,data}       # create mntpnt for subvols

# mount subvols
sudo mount -o defaults,subvol=@backups /dev/sda2 /mnt/backups
sudo mount -o defaults,subvol=@data /dev/sda2 /mnt/data
lsblk # to check if all worked out
```
Add the two subvolumes to the `fstab` using the `UUID` of the parent partition. Test if the new `fstab` is working by unmounting the volumes and then automically mounting all volumes in the `fstab` by running `sudo mount -a`. For the following, only the `@backups` subvolume is used. You should now have:
- btrfs system partition with subvols `@` with an operating system, `@home` with the home dirs and a folder `/btrbk-snapshots`.
- btrfs backup partition with a subvol `@backups`. This can theoretically also be a folder. In my case, it is a folder inside of the subvolume where the backups will be stored: `@backups` mounted at `mnt/backups` containing `/btrbk-backups`.

### BTRBK
[btrbk](https://github.com/digint/btrbk) is a minimal cli-based package that creates snapshots and backups of a btrfs subvolumes. It works on top of a configuration file and can be scheduled with cron jobs.

#### 1. Setup
```sh
sudo mkdir /mnt/archlinux/btrbk-snapshots
sudo mkdir /mnt/backups/btrbk-backups
```
Create a btrbk [configuration file](btrbk.conf) and store it in 
`/etc/btrbk/btrbk.conf`. I used the provided example file (stored in 
`/etc/btrbk/btrbk.conf.example`)and store it in in 
`/home/weygoldt/Data/projects/backup-arch/btrbk.conf` to be able to track it 
with git. Either this path needs to be hard-coded into the run-script or you 
can symlink it to the location it is supposed to be. Always use the full path 
when creating a symlink. This makes things much easier:
```sh
# make a symlink:
sudo ln -s /home/weygoldt/Data/projects/backup-arch/btrbk.conf /ect/btrbk/btrbk.conf
```

#### 2. Test the setup
To test if the configuration file works, do a dry-run:
```sh
# If conf is symlinked:
sudo btrbk -v -n run
# If conf is somewhere else:
sudo btrbk -c <path-to-conf> -v -n run
```
 for a dry-run. The `-c` flag adds the path to the config file, the `-v` flag 
 adds verbose output and the `-n` flag activates dry run. If no errors occur, 
 the first real snapshots can be taken with

```sh
# to make a snapshot
sudo btrbk -v snapshot
```
The output should indicate that a snapshot was taken but no backup was taken. 
The snapshot should be stored at `/mnt/archlinux/btrbk-snapshots`. With the 
snapshots in place, the first backup can be created now with
```sh
# to make a backup
sudo btrbk -v resume
```
This will require some time since the first backup will **not** be incremental, 
because logically, only the following backups can be incremental. If both 
snapshots and backups can be generated manually, this can be automated using  
run-script in a cron-job.

#### 3. Scheduling snapshots and backups
Configure a [script](btrbk) as a cron job to run snapshots and backups hourly 
by adding a shell script. 

File: /home/weygoldt/Data/system/backup-arch/btrbk
```sh
#!/bin/bash
exec /usr/bin/btrbk -q run # -q for quiet
```

Run `sudo chmod +x btrbk` to make it executable. The 
path to the script can now be added to the root user crontab like this:

```sh
su # change to root user
crontab -e # edit crontab, might have to set editor first
```

Then add the line

```sh
0 * * * * /home/weygoldt/Data/system/backup-arch/btrbk
```

To run the script to which the path is pointing at every full hour.

This should run a snapshot and backup pair quietly at every full hour.

To list recent snapshots and their backups, use `sudo btrbk list latest` or `... list all` to list the latest or all snapshots and respective backups, which should refresh hourly. If the conf is not symlinked, add the `-c` flag and the path again.

### Restoring from snapshots or backups
Restoring a subvolume has to be done manually. Assume the system failed to boot. To drop to a tty use `ctrl+alt+f2` and login as root. The general procedure is as follows:

**Restore snapshot**
- Identify latest working snapshot
- Move broken subolume away (e.g. rename)
- Create read-write subvol from read-only snapshot with the name of the broken subvolume

**Restore backup**
- Identify latest working backup
- Send backed up snapshot to broken root filesystem
- Proceed as with a snapshot

**Additional notes:**
The following procedure works from a fully running desktop environment (i.e. you can move the root subvolume while it is running!) as well as from a live iso or recovery mode. Just make sure to also edit the fstab, since the root subvolume may be mounted with the subvolid as well, which will change if you swith to a snapshot subvolume.

#### 1. Identify subvolume to restore from
List available snapshots with
```sh
# list snapshots
btrbk -c /path/to/btrbk.conf list snapshots
# list snapshots and backups
btrbk -c /path/to/btrbk.conf list snapshots
# list recent
btrbk -c /path/to/btrbk.conf list latest
# alternative: list all subvolumes
btrbk ls /
btrbk ls -L /
```
From the list identify the snapshot to restore, e.g. `/mnt/archlinux/btrbk-snapshots/@.latest`.

#### 2. Restore backup (under construction)
(skip if restoring from a snapshot)
To send a snaptshot from a locally mounted backup disk to a destroyed root partition, mount the root device (here at /mnt/archlinux) and send the snapshot to the root device by
```sh
btrfs send /mnt/backups/@.latest | btrfs receive /mnt/archlinux/
```

If the root device still has a functional parent snapshot (e.g. I accidentally deleted or somehow lost the latest snapshot), the snapshot and backup-pair should be listed under snapshot_subvol and target_subvol e.g. when running `btrbk list all`
```sh
btrfs send -p /mnt/send/parent /mnt/backups/@.latest | btrfs receive /mnt/archlinux/
```
>**NOTE:** As of yet, I am unsure what exactly a parent snapshot is. According to the [docs](https://btrfs.readthedocs.io/en/latest/btrfs-subvolume.html#subvolume-and-snapshot) _parent here means the subvolume which contains this subvolume_. This would mean that all snapshots taken before should be parents. However if there is a gap in the "snapshot-chain" it could happen that changes that happened during that gap are not present in the latest "child" snapshot and thus are lost (?).

#### 3. Create read-write subvolume 
To create a read-write subvolume, just create a read-write snapshot of the snapshot you just moved into the root directory from a backup or the lates snapshot in the snapshot folder.
```sh
# first move broken subvolume away, e.g. the root if I broke the system
mv /mnt/archlinux/@ /mnt/archlinux/@.BROKEN

# then create a read-write subvol
btrfs subvolume snapshot /mnt/archlinux/@.latest /mnt/archlinux/@
```

Now we should be able to boot into the new @ subvolume as the system root directory.

#### 4. Cleanup
If all went fine, delete the broken subvolume.
```sh
btrfs subvolume delete /mnt/archlinux/@.BROKEN
```
Keep the `@.latest` on both disks until a new snapshot is created to keep the incremental chain alive.

## Btrfs filesystem errors
Btrfs has great snapshot abilities, but because all files are checksummed, easily runs into errors and then refuses to mount. The first step to fix such issues are to "scrub" the files system, if this does not work try to boot with a backup btrfs root tree. Do **not** run `btrfs check --repair`!
```sh
#scrub
btrfs scrub start /dev/sdaX
# monitor with
btrfs scrub status /dev/sdaX

# backup root tree
mount -o usebackuproot /dev/sdaX /mnt
```
If something catastrophic happens and an un-backupped btrfs filesystem is corrupted, the data that is still left on the device and can be recovered can be transferred to a second device with 
```sh
btrfs restore /dev/broken /mnt/usbdrive
```
There are some additional rescue options that can be used to restore the file system in place. If the above steps where all taken (including the restore!) try the following
```sh
btrfs rescue super-recover /dev/broken
btrfs rescue zero-log /dev/broken
btrfs rescue fix-device-size /dev/broken
btrfs rescue chunk-recover /dev/broke # very slow
```

## Data backups
All valuable data is incrementally backupped via snapshots of the home directory. Additionally, a [script](./ext-databackup.sh) is used to automatically sync a folder to an external SSD.

## Project backups
For another backup and for version control, repositories I casually modify are automatically pushed to Github using my [autopush script](autopush-git.sh).