Clone dotfiles into current system

```bash
dfs checkout
```

Clone dotfiles into new system (adjust shell if nessecary)

```sh
echo 'alias dfs="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"' >> $HOME/.zshrc
source ~/.zshrc
echo ".dotfiles" >> .gitignore
git clone --bare https://www.github.com/weygoldt/dotfiles $HOME/.dotfiles
dfs checkout
dfs config --local status.showUntrackedFiles no
```

To run conky on startup, create a symlink in `/etc/profile.d` by running
```sh
cd /etc/profile.d
sudo ln -s /home/weygoldt/.conky/conky-startup.sh
```
This will launch conky before kde plasma arranges the monitors.
If conky is supposed to follow the primary screen, add it as a system startup script in kde settings instead.