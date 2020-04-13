#!/bin/bash

tmux list-sessions | grep Routine
if [[ $? == 0 ]] ;then
    tmux attach -t Routine
else
    tmux new-session -s Routine
fi
