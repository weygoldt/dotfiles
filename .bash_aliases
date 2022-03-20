# Variables
datap=/mnt/data
unip=/mnt/data/uni
obsidianp=/mnt/data/obsidian-master
espansop=/home/weygoldt/.config/espanso/match

# Aliases
## Git helpers
alias dotfiles='/usr/bin/git --git-dir=/home/weygoldt/.dotfiles/ --work-tree=/home/weygoldt'
alias gitlog='git log --graph --oneline --decorate'
alias gitc='git commit -am' # changes and deletions
alias gitca='git add . && git commit -m' # stage and commit all files

## Download tool
alias audiodl='torsocks -i youtube-dl -f bestaudio -x --audio-format "mp3" --embed-thumbnail --add-metadata'
alias videodl='torsocks -i youtube-dl -f best'

## Most used paths
alias uni='cd $unip'
alias data='cd $datap'
alias obsidian='cd $obsidianp'
alias espans='cd $espansop'

## Use conda to run python script 
alias crun='conda run python' # run a python script with conda base env (must be active)

## Bash helpers
alias ll='ls -la' # list all files
alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | egrep ^/dev/ | sort" # list mounted drives only
alias cpv='rsync -ah --info=progress2' # copy with progress bar