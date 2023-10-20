#!/bin/zsh

# Check if Kitty is running
if id=$(pgrep -fl kitty.app); then
  kitty --single-instance
else
  open -a kitty --args --single-instance
fi
