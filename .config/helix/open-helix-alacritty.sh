#!/bin/zsh -l

working_dir="$1"
shift
arguments="$@"

alacritty msg create-window --working-directory "$working_dir" --command zsh -l -c "zellij ac go-to-tab-name -c open-files; zellij ac write-chars \"hx $arguments\"; zellij ac write 13"

if [ $? -ne 0 ]; then
    alacritty --hold --working-directory "$working_dir" &
    sleep 1
    zellij ac go-to-tab-name -c open-files
    zellij ac write-chars "hx $arguments"
    zellij ac write 13 &
fi
