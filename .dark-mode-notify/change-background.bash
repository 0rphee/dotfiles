#!/bin/bash

export PATH="/opt/homebrew/bin/:/usr/local/bin:$PATH"

# Check the system settings to obtain the theme mode
mode="light" # default value
val=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
if [ $? -eq 0 ]; then
  mode="dark"
fi

case $mode in
  dark)

    # Change alacritty theme to gruvbox-dark
    # alacritty-themes gruvbox-dark

    # Change kitty theme to Gruvbox Dark
    # kitty +kitten themes --reload-in=all "Gruvbox Dark"

    total_lines=$(wc -l < "/Users/roger/.config/kitty/kitty.conf")
    sed -i '' "${total_lines}s/.*/include gruvbox-dark.conf/" "/Users/roger/.config//kitty/kitty.conf"
    kill -SIGUSR1 $(pgrep -a kitty)

    # Change helix theme to my-gruvbox
    sed -i '' '1s/.*/theme = "my-gruvbox"/' "/Users/roger/.config/helix/config.toml"
    pkill -USR1 hx

    # Change zellij theme
    sed -i '' '$s/.*/theme "my-gruvbox-dark"/' "/Users/roger/.config/zellij/config.kdl"

    ;;
  light)
    # Change alacritty theme to gruvbox-light
    # alacritty-themes gruvbox-light

    # Change kitty theme to Gruvbox Light
    # kitty +kitten themes --reload-in=all "Gruvbox Light"
    total_lines=$(wc -l < "/Users/roger/.config/kitty/kitty.conf")
    sed -i '' "${total_lines}s/.*/include gruvbox-light.conf/" "/Users/roger/.config//kitty/kitty.conf"
    kill -SIGUSR1 $(pgrep -a kitty)

    # Change helix theme to my-gruvbox-light
    sed -i '' '1s/.*/theme = "my-gruvbox-light"/' "/Users/roger/.config/helix/config.toml"
    pkill -USR1 hx

    # Change zellij theme
    sed -i '' '$s/.*/theme "my-gruvbox-light"/' "/Users/roger/.config/zellij/config.kdl"
    ;;
esac

