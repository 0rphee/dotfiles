#!/bin/zsh

choices=$(cat "$HOME/.config/helix/projects")
choices+="$(echo -e "\nscratchpad")"

# Prompt the user to choose a project
choice=$(printf '%s' "$choices" | fzf --height=40% --layout=reverse --info=inline --border --margin=1 --padding=1) ||hx # zellij run -- hx

if [[ "$choice" = "scratchpad" ]]; then
    hx
elif [[ -n "$choice" ]]; then
    echo $choice
    # open new tab and open the project there
    # id=$(wezterm cli spawn zsh -l -c "cd $choice; exec zsh")
    # wezterm cli activate-tab --tab-index -1
    # wezterm cli send-text --pane-id "$id" "hx $choice"
    # echo | wezterm cli send-text --pane-id $id

    # in current pane open project
    wezterm cli send-text "cd $choice;hx $choice"
    echo | wezterm cli send-text 

    # previous zellij config
    # zellij ac write-chars "hx $choice"
    # zellij ac write 13
    # zellij run --cwd $choice -- hx
fi
