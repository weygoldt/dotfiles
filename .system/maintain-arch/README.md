# My arch linux system maintenance workflow
**Disclaimer:** This was created for personal documentation of my setup to make my setup more reproducible. Do not use this as a guide.

A collection of useful commands to keep arch linux clean inspired by a video of [eflinux](https://www.youtube.com/watch?v=wwSkFi3h2nI) and the arch wiki on [system maintenance](https://wiki.archlinux.org/title/System_maintenance).

## System

### 0. Make a snapshot!!!
```sh
sudo btrbk run
```
### 1. Check for failed systemd services
```sh
systemctl --failed
```

### 2. Look through log files
```sh
sudo journalctl -p 3 -xb
```

### 3. Update system
```sh
sudo pacman -Syyu    # for main repositories only
paru -Syyu           # for all repositories
flatpak update       # for flatpak updates
conda update -n base -c defaults conda # to update conda 
```
### 4. Clean .cache
```sh
du -sh .cache   # show cache size
rm -rf .cache/* # delete all inside .cache
du -sh .cache   # recheck size
```

### 5. Check .config
Make sure that only unneeded files are deleted here.
```sh
du -sh .config/
```

### 6. Check journal
Different options for the journalctl flat --vacuum are listed in the journalctl manpage.
```sh
du -sh //var/log/journal/ # show journal size
sudo journalctl --vacuum-time=2weeks # cleans all older than 2 weeks
```

## Pacman
### 1. Check pacman cache
The  cache where packages are stored, both installed and uninstalled. It is **not** advised to delete the full pacman cache. Only delete packages from the cache that are not installed.
To delete the cached packages that are not currently installed use
```sh
sudo pacman -Sc     # for main repositories only
paru -Sc            # for all repositories
```

### 2. Clean unwanted dependencies
```sh
pacman -Qdt                 # to list dep.
sudo pacman -Rsn $(pacman -Qdtq) # remove them
paru --clean                # this works as well
```

### 3. Uninstall orphaned packages
```sh
pacman -Qtdq                # list orphans
sudo pacman -Rns $(pacman -Qdtq)    # remove them
```

### 7. Keep mirror list fresh
Make sure the correct countries are listed in `sudo vim /etc/xdg/reflector/reflector.conf`. To automatically refresh mirrors once a week use
```sh
sudo systemctl enable reflector.service reflector.timer
sudo systemctl start reflector.service reflector.timer
```
To refresh mirrors now use
```sh
sudo systemctl start reflector.service
```
To check the generated mirrorlist use 
```sh
cat /etc/pacman.d/mirrorlist
```

## Start the file indexer
I disabled the file indexer on startup because of its high ram usage in idle. 
This reduces the RAM usage from ~3GiB to 0.8GiB in idle.
To index files that accumulated during the inactivity of the indexer start it by
```sh
balooctl enable
balooctl check # to start checking for new files

# To see if there are no pending files to be indexed
balooctl status
# Or to monitor what it is doing
balooctl monitor

# If it is finished, run
balooctl disable
```

## Btrbk snapshots and backups
Check if the latest snapshots and backups are performed as planned.
```sh
sudo btrbk list all
sudo btrbk list latest
```

## Check space usage of the file system
This needs btrfs-specific commands. Simple `df` will miscalculate disk usage:
```sh
btrfs filesystem show / # or
btrfs filesystem df /   # or
btrfs filesysten usage /
```

## In case of unbootable system
Hit `ctrl alt f2` to drop to the terminal, then login and follow the btrbk backup procedure.

## Restart plasmashell

```sh
kbuildsycoca5 && kquitapp5 plasmashell && kstart5 plasmashell
```