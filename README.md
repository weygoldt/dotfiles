Clone dotfiles into current system

```bash
dotfiles checkout
```

Clone dotfiles into new system (adjust shell if nessecary)

```bash
echo 'alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"' >> $HOME/.bashrc
source ~/.bashrc
echo ".dotfiles.git" >> .gitignore
git clone --bare https://www.github.com/weygoldt/repo.git $HOME/.dotfiles.git
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
```

To run conky on startup, create a symlink in `/etc/profile.d` by running
```sh
cd /etc/profile.d
sudo ln -s /home/weygoldt/.conky/conky-startup.sh
```
This will launch conky before kde plasma arranges the monitors.
If conky is supposed to follow the primary screen, add it as a system startup script in kde settings instead.