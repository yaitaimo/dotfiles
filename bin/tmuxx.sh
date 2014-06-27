#!/bin/zsh

# attach to an existing tmux session, or create one if none exist
# also set up access to the system clipboard from within tmux when possible

if [[ ( $# -eq 1 ) && ( $1 == "ls" ) ]]; then
    tmux ls
else 
    if [[ ( $OSTYPE == darwin* ) && ( -x $(which reattach-to-user-namespace 2>/dev/null) ) ]]; then
        # on OS X force tmux's default command to spawn a shell in the user's namespace
        # https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard
        tweaked_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
        if [ $# -eq 1 ]; then
            tmux attach -t $1 || tmux -f <(echo "$tweaked_config") new-session -s $1 -n zsh
        else
            tmux attach || tmux -f <(echo "$tweaked_config") new-session -n zsh
        fi
    else
        if [ $# -eq 1 ]; then
            tmux attach -t $1 || tmux new-session -s $1
        else
            tmux attach || tmux new-session
        fi
    fi
fi
