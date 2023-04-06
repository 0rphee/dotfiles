#!/usr/bin/env bash

# Detects if Alacritty is running
# this doesnt work for whatever reason: pgrep -f "Alacritty" > /dev/null 2>&l
# a bit faster with yabai, but here's an alternative: ps uxww | grep -c -i -e alacritty
# NOTE: if run manually, the script will malfunction, because, for some reason, yabai 
#       will catch the terminal title, and grep will count it, despite none alacritty
#       instance running
Query=$(yabai -m query --windows | grep -c -i -e "\"app\":\"Alacritty\"" | awk '{ if ($1>0) {print 1} else {print 0} }')
read a <<< $Query

if [ "$a" == "0" ]; then
    open -a "/Applications/Alacritty.app"
    echo "awk result: $a \n USING OPEN"
else
    # Create a new window
    alacritty msg create-window
    echo "awk result: $a \n USING MSG"
    # script='tell application "iTerm" to create window with default profile'
    # ! osascript -e "${script}" > /dev/null 2>&1 && {
    #     # Get pids for any app with "iTerm" and kill
    #     while IFS="" read -r pid; do
    #         kill -15 "${pid}"
    #     done < <(pgrep -f "iTerm")
    #     open -a "/Applications/iTerm.app"
    # }
fi
