#!/bin/sh

export PATH="/opt/homebrew/bin/:/usr/local/bin:$PATH"

# Check the system settings to obtain the theme mode
mode="light" # default value
val=$(defaults read -g AppleInterfaceStyle 2>/dev/null)
if [ $? -eq 0 ]; then
  mode="dark"
fi

case $mode in
  dark)

    # chosen_theme="gruvbox-dark"
    chosen_theme="everforest-dark"

    ;;
  light)

    # chosen_theme="gruvbox-light"
    chosen_theme="everforest-light"

    ;;
esac

ln -sf "$HOME/.config/helix/themes/my-${chosen_theme}.toml" "$HOME/.config/helix/themes/current-theme.toml"
pkill -USR1 hx &

ln -sf "$HOME/.config/kitty/themes/${chosen_theme}.conf" "$HOME/.config/kitty/themes/current-theme.conf"
pkill -USR1 kitty &
