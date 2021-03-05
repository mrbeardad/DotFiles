#!/bin/bash
xdotool key --window $(xdotool search --limit 1 --all --pid $(pgrep TIM.exe)) "ctrl+alt+Z"
