#!/usr/bin/env bash 

### AUTOSTART PROGRAMS ###
if systemd-detect-virt --quiet; then
    lxsession &
    sleep 1
    killall picom
    xrandr -s 1920x1080 &
else
    lxsession &
fi

dunst -conf "$HOME"/.config/dunst/colorscheme &
sleep 1

# Wallpapers
feh --recursive --bg-scale --randomize ~/.wallpapers
