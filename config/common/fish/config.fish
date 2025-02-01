if status is-interactive
    # Commands to run in interactive sessions can go here
end

zoxide init fish | source
s739 generate fish | source

set -g fish_greeting
set -g async_prompt_functions _pure_prompt_git

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/vvh413/.cache/lm-studio/bin
