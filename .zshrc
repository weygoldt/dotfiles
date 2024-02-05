# Enable colors and change prompt:

# PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}#%b "
# RPS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}#%b "

# source zsh aliases
source $HOME/.config/zsh/zsh_aliases

# History in cache directory:
HISTFILE=$HOME/.config/zsh/zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload -U compinit; compinit

# Turn off all beeps
unsetopt BEEP

# Set default editor
export EDITOR='/usr/bin/nvim'
export VISUAL='/usr/bin/nvim'

# add user to path
export PATH="$HOME/.local/bin:$PATH"

# whatever this means?
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git cvs svn

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}
RPROMPT=$'$(vcs_info_wrapper)'

# Keybindings
bindkey -v # enable vim mode
bindkey ^R history-incremental-search-backward 
bindkey ^S history-incremental-search-forward
bindkey '^ ' autosuggest-accept # bind strg+space to accept

# for colorful manpages
export PAGER="most"

# for 1password to manage ssh keys
# export SSH_AUTH_SOCK=~/.1password/agent.sock

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

eval "$(starship init zsh)"
export VIRTUAL_ENV_DISABLE_PROMPT=tr

eval "$(direnv hook zsh)"

fpath+=~/.zfunc
autoload -Uz compinit && compinit

export TERM="xterm-kitty"
export RANGER_LOAD_DEFAULT_RC=false
