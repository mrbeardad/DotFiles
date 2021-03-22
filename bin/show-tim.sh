#!/bin/bash
# 用于将 Ctrl+Alt+Z 映射给wine上的tim，快捷键开关tim窗口
xdotool key --window $(xdotool search --limit 1 --all --pid $(pgrep TIM.exe)) "ctrl+alt+Z"
