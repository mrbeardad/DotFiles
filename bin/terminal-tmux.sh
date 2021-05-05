#!/bin/bash

tmuxSessions=$(tmux list-sessions | cut -f1 -d' ' | xargs)

if [[ -z "$1" ]] ;then
    { echo "$GIO_LAUNCHED_DESKTOP_FILE" | grep -q guake && sessionName=Guake; } \
        || { echo "$GIO_LAUNCHED_DESKTOP_FILE" | grep -q xfce4 && sessionName=Xfce4; } \
        || { [[ -n "$GNOME_TERMINAL_SERVICE" ]] && sessionName=Gnome; } \
        || sessionName=Manjaro
else
    sessionName="$1"
fi

if [[ "$tmuxSessions" == *"$sessionName:"* ]] ;then
    exec tmux attach -t "$sessionName"
else
    exec tmux new-session -s "$sessionName"
fi
