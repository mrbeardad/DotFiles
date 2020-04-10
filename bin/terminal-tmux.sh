#!/bin/bash

if ps -le | grep 'tmux: server' ;then
    tmux a
else
    tmux new -s today
fi
