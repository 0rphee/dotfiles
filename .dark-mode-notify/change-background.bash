#!/bin/bash

export PATH="/opt/homebrew/bin/:/usr/local/bin:$PATH"


change_background() {
  # change background to the given mode. If mode is missing,
  # we try to deduct it from the system settings.
  mode="light" # default value
  if [ -z "$1" ]; then
    val=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
    if [ $? -eq 0 ]; then
      mode="dark"
    fi
  else
    case $1 in
      light)
        osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = false" >/dev/null
        mode="light"
        ;;
      dark)
        osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = true" >/dev/null
        mode="dark"
        ;;
    esac
  fi

  case $mode in
    dark)

      # change alacritty
      # sed -i '' '$s/.*/theme: gruvbox-dark/' "/Users/roger/.config/alacritty/alacritty.yml"
      alacritty-themes gruvbox-dark

      # change helix
      sed -i '' '1s/.*/theme = "my-gruvbox"/' "Users/roger/.config/helix/config.toml"
      pkill -USR1 hx
      ;;
    light)
      # change alacritty
      # sed -i '' '$s/.*/theme: gruvbox-light/' "/Users/roger/.config/alacritty/alacritty.yml"
      alacritty-themes gruvbox-light

      # change helix
      sed -i '' '1s/.*/theme = "my-gruvbox-light"/' "/Users/roger/.config/helix/config.toml"
      pkill -USR1 hx
      ;;
  esac
}

change_background "$@"
