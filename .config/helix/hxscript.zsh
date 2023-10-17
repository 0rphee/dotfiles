#!/bin/zsh

choices=$(cat "$HOME/.config/helix/projects")
choices+="$(echo -e "\nscratchpad")"

# Prompt the user to choose a project
choice=$(printf '%s' "$choices" | fzf --preview="ls {}" --height=40% --layout=reverse --info=inline --border --margin=1 --padding=1)

if [[ "$choice" = "scratchpad" ]]; then
    hx
elif [[ -n "$choice" ]]; then
    escapedChoice=$(eval echo $choice)
    cd $escapedChoice

    if [[ "$1" = "-l" ]]; then
        kitty @ launch --cwd="$PWD" --type="tab" --dont-take-focus lazygit > /dev/null
    fi

    if [[ "$1" = "-o" ]]; then
        hx $escapedChoice
    fi
fi

