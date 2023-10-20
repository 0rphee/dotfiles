#!/bin/zsh

# Check if wezterm-gui is running
if pgrep -x wezterm-gui >/dev/null; then
  wezterm cli spawn --new-window
else
  open -a WezTerm
fi
