#!/bin/bash

tmux list-sessions | grep Routine
if [[ $? == 0 ]] ;then
    tmux attach -t Routine
else
    tmux -f ~/.tmux/tmux.conf new-session -s Routine
fi
