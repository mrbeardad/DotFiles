#!/bin/bash

if [[ "$1" == "-f" ]] ;then
    option="-f"
elif [[ "$1" == "-n" ]] ;then
    option="-n"
else
    option="-i"
fi

cp $option -vu ~/.cheat/*.md cheat
cp $option -vu ~/.gdbinit gdb/gdbinit
cp $option -vu ~/.cgdb/cgdbrc gdb
cp -vru ~/.local/share/fcitx5/rime/* rime-dict
cp $option -vu ~/.tmux/tmux.conf tmux
cp $option -vu ~/.config/xfce4/terminal/terminalrc xfce4-terminal
cp $option -vu ~/.zshrc zsh/zshrc
cp $option -vu ~/.config/dconf/user gnome

