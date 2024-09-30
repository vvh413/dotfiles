if status is-interactive
    # Commands to run in interactive sessions can go here
end

mcfly init fish | source
zoxide init fish | source
s739 generate fish | source
starship init fish | source

set -g fish_greeting
