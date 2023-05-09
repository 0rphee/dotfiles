#!/bin/zsh

choices=$(cat "$HOME/.config/helix/projects")
choices+="$(echo -e "\nscratchpad")"

# Prompt the user to choose a project
choice=$(printf '%s' "$choices" | fzf --height=40% --layout=reverse --info=inline --border --margin=1 --padding=1) || zellij run -- hx


if [[ -n "$choice" ]]; then
    echo $choice
    zellij ac write-chars "hx $choice"
    zellij ac write 13
    # zellij run --cwd $choice -- hx
elif [[ "$choice" = "scratchpad" ]]; then
    zellij run -- zsh -ic hx
fi
