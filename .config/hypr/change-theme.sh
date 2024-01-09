#!/bin/sh

# Check the system settings to obtain the theme mode
# mode="dark" # default value

HOME="/home/orphee"

# List of themes
themes=("everforest-light" "everforest-dark" "gruvbox-dark" "gruvbox-light")

chosen_theme=$(printf "%s\n" "${themes[@]}" | anyrun --plugins ~/.config/anyrun/plugins/libstdin.so --show-results-immediately true)

# Check if the chosen theme is valid
if [[ -n "$chosen_theme" ]]; then
    # Update the symlink
    ln -sf "$HOME/.config/helix/themes/my-${chosen_theme}.toml" "$HOME/.config/helix/themes/current-theme.toml" &
    pkill -USR1 hx &

    ln -sf "$HOME/.config/kitty/themes/${chosen_theme}.conf" "$HOME/.config/kitty/themes/current-theme.conf" &
    pkill -USR1 kitty &

    ln -sf "$HOME/.config/waybar/themes/${chosen_theme}.css" "$HOME/.config/waybar/themes/current-theme.css"
    pkill waybar; sleep 0.2; hyprctl dispatch exec waybar &

    ln -sf "$HOME/.config/anyrun/themes/${chosen_theme}.css" "$HOME/.config/anyrun/themes/current-theme.css"

    if [[ "$chosen_theme" == *"light"* ]]; then
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-light' &
    else
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' &
    fi
    
    dunstify "Theme set to: ${chosen_theme}"
else
    dunstify "No theme selected, no changes made"
fi
