#!/bin/bash

cp -rvu /etc/hosts hosts
cp -rvu /etc/dnsmasq.conf dnsmasq.conf
cp -rvu ~/.cache/cppman/* cppman/
cp -rvu ~/.config/fcitx/* fcitx/
cp -rvu ~/.config/fcitx5/* fcitx5/
cp -rvu ~/.local/share/fcitx5/themes/* fcitx5/themes
cp -rvu ~/.local/share/fcitx5/rime/* rime-dict
cp -rvu ~/.gdbinit gdb/gdbinit
cp -rvu ~/.cgdb/cgdbrc gdb/cgdbrc
cp -rvu ~/.config/dconf/user gnome/
cp -rvu ~/.tmux.conf tmux/tmux.conf
cp -vu ~/.config/xfce4/terminal/terminalrc xfce4-terminal
cp -vu ~/.zshrc zsh/zshrc

