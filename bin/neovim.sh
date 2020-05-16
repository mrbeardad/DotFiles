#!/bin/bash

tmux list-sessions | grep -q Develop
if [[ $? == 0 ]] ;then
    tmux attach -t Develop
else
    tmux -f ~/.tmux/tmux.conf new-session -s Develop 'XFCE4_TERM=1 nvim'
fi
