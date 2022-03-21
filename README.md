# Dotfiles
A collection of configuration files and useful scripts I keep in my home directory.

## Clone dotfiles on configured system
```bash
dfs checkout
```

## Clone dotfiles into new system 
...  and adjust the default shell if nessecary.
```sh
echo 'alias dfs="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"' >> $HOME/.zshrc
source ~/.zshrc
echo ".dotfiles" >> .gitignore
git clone --bare https://www.github.com/weygoldt/dotfiles $HOME/.dotfiles
dfs checkout
dfs config --local status.showUntrackedFiles no
```

## Conky
... requires conky to be installed. If conky is supposed to follow the primary screen, add it as a system startup script in kde settings. The startup script can also be executed before kde starts but will not follow changing monitor configurations (best for desktop pcs). To run conky on startup, create a symlink in `/etc/profile.d` by running
```sh
# to launch before kde
cd /etc/profile.d
sudo ln -s /home/weygoldt/.conky/conky-startup.sh
```

## Scripts
A collection of scripts to automate backups to external drives and autopush all my git repos from time to time.