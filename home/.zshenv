export PATH=$PATH:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.local/bin
export EDITOR=nvim
export LESS="$LESS -+F"

source $HOME/.nnn
# alias ssh='TERM=xterm-256color ssh'
alias x='cd "$(xplr --print-pwd-as-result)"'
. "$HOME/.cargo/env"