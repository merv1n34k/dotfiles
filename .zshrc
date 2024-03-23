# Homebrew setup for arm64 architecture
# See https://github.com/zegervdv/homebrew-zathura/issues/99#issuecomment-1356384136
if [[ $(uname -m) == 'arm64' ]]; then
    BREWPATH=/opt/homebrew/bin:/opt/homebrew/sbin
else
    BREWPATH=/usr/local/bin
fi
# dbus setup
export DBUS_SESSION_BUS_ADDRESS="unix:path=$DBUS_LAUNCHD_SESSION_BUS_SOCKET"


# Use up-to-date GNU's coreutils
export PATH=/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH,$BREWPATH:$PATH
#> Warning: may interfere with GMP builds and make some builds fail


# Neofetch - a bloated kitsch which takes 3 seconds of your life every time
#neofetch

# Proper history configuration for zsh
export HISTFILE=~/.zsh_history
export HISTFILESIZE=999999
export HISTSIZE=999999
export HISTCONTROL=erasedups
export SAVEHIST=99999
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
#setopt HIST_IGNORE_SPACE # Omit commands which begin with space
#setopt HIST_FIND_NO_DUPS
#setopt HIST_SAVE_NO_DUPS

# Neat aliases

# note: aliases contain commands from
# GNU's coreutils which start with `g`

## Go to parent fast
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

## Colorize the ls output
alias ls='gls --color=auto -F'

## Use a long listing format
alias ll='gls -lha'

## Show hidden files ##
alias l.='gls -d .*'

alias h='history'
alias c='clear'
alias tree='tree -C'

## Make some commands `safer`
alias mv='gmv -i'
alias cp='gcp -i'
alias ln='gln -i'

## PS: NEVER EVER USE -f ARGUMENT AS IT IGNORES THE -I! Your projects and mental health WILL suffer!
alias rm="grm -I"

## Mics
### cd to Config
alias C="cd ~/.config"
### cd to Nvim
alias N="cd ~/.config/nvim"

# Configure Python working environment
# See https://medium.com/@henriquebastos/the-definitive-guide-to-setup-my-python-workspace-628d68552e14
export WORKON_HOME=~/.ve
export PROJECT_HOME=~/workspace_python
eval "$(pyenv init -)"
pyenv virtualenvwrapper_lazy
