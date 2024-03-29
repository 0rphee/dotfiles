# clippy and status line
set-option global ui_options terminal_assistant=cat terminal_status_on_top=true

# scroll-off (margin around the cursor 8 lines, 3 columns)
set-option global scrolloff 8,3

# add line numbers
add-highlighter global/ number-lines -relative -hlcursor

# add softwrap
add-highlighter global/ wrap -indent -marker '↪ '

# add whitespace rendering
add-highlighter global/ show-whitespaces

# add highlighting of matching brackets/braces/etc
add-highlighter global/ show-matching

# buffer-next/buffer-previous:  gn gp
map -docstring "next buffer" global goto n "<esc>: buffer-next<ret>: info buffer-next<ret>"
map -docstring "previous buffer" global goto p "<esc>: buffer-previous<ret>: info buffer-previous<ret>"

# delete-buffer/delete-buffer! <space>C <space>C
map -docstring "close current buffer" global user c ": delete-buffer<ret>: info 'buffer deleted'<ret>"
map -docstring "CLOSE CURRENT BUFFER! even if the buffer is not saved" global user C ": delete-buffer!<ret>: info 'buffer FORCEFULLY deleted!'<ret>"

# quit/quit! <space>C <space>C
map -docstring "quit session" global user q ": quit<ret>"
map -docstring "QUIT!!! even if some buffers are not saved" global user Q ": quit!<ret>"

# write/write! <space>C <space>C
map -docstring "write current file" global user W ": write<ret>: info 'current file written'<ret>"
# map -docstring "WRITE CURRENT FILE! even when the file is protected" global user W ": write!<ret>: info 'current file FORCEFULLY written!'<ret>"

# comment lines (like helix)
map -docstring "comment-out current line" global normal <c-a-c> ":comment-line<ret>"

# copy/paste to system clipboard [MAC ONLY]
map -docstring "copy to system clipboard" global user y "<a-|> pbcopy<ret>: info 'selection copied to system clipboard'<ret>"
map -docstring "paste before selection from system clipboard" global user P "! pbpaste<ret>: info 'system clipboard pasted before selection'<ret>"
map -docstring "paste after selection from system clipboard" global user p "<a-!> pbpaste<ret>: info 'system clipboard pasted after selection'<ret>"


# char command, like helix
define-command char %{
    echo %sh{
        ch=$(printf "\\$(printf '%03o' "$kak_cursor_char_value")")
        printf '"%s" (U+%04X) Dec %d Hex %02X\n' "$ch" "$kak_cursor_char_value" "$kak_cursor_char_value" "$kak_cursor_char_value"
    }
}

# alt kitty window split command
define-command kitty-terminal-window-splits -params 1.. -docstring '
kitty-terminal-window <vsplit|hsplit> <program> [<arguments>]: create a new terminal as a kitty window
The program passed as argument will be executed in the new terminal' \
%{
    nop %sh{
        match=""
        if [ -n "$kak_client_env_KITTY_WINDOW_ID" ]; then
            match="--match=window_id:$kak_client_env_KITTY_WINDOW_ID"
        fi

        listen=""
        if [ -n "$kak_client_env_KITTY_LISTEN_ON" ]; then
            listen="--to=$kak_client_env_KITTY_LISTEN_ON"
        fi

        split_loc=$1
      	shift 1

        rest=""
        if [ ${#@} -gt 1 ]; then
            rest="-e $@"
        fi

        kitty @ $listen launch --no-response --location "$split_loc" --type="$kak_opt_kitty_window_type" --cwd="$PWD" $match kak -c $kak_session $rest
    }
}

complete-command kitty-terminal-window-splits command

# imitates helix keybindings 
declare-user-mode user-window
map -docstring "user mode for managing kakoune clients in the same session" global user w ": enter-user-mode user-window<ret>"

map -docstring "create new kakoune vsplit in kitty" global user-window v ": kitty-terminal-window-splits vsplit<ret>: info 'kitty kak vsplit created'<ret>"
map -docstring "create new kakoune hsplit in kitty" global user-window s ": kitty-terminal-window-splits hsplit<ret>: info 'kitty kak hsplit created'<ret>"

# Use Tab for both indenting and completion from wiki
hook global InsertCompletionShow .* %{
    try %{
        # this command temporarily removes cursors preceded by whitespace;
        # if there are no cursors left, it raises an error, does not
        # continue to execute the mapping commands, and the error is eaten
        # by the `try` command so no warning appears.
        execute-keys -draft 'h<a-K>\h<ret>'
        map window insert <tab> <c-n>
        map window insert <s-tab> <c-p>
        hook -once -always window InsertCompletionHide .* %{
            unmap window insert <tab> <c-n>
            unmap window insert <s-tab> <c-p>
        }
    }
}

# change tabs to spaces
map global insert <tab> '<a-;><a-gt>'
map global insert <s-tab> '<a-;><a-lt>'

# plugin manager, kak-bundle (https://github.com/jdugan6240/kak-bundle)
source "%val{config}/bundle/kak-bundle/rc/kak-bundle.kak"
bundle-noload kak-bundle https://github.com/jdugan6240/kak-bundle.git

# kak-crosshairs
bundle kak-crosshairs https://github.com/insipx/kak-crosshairs.git %{
    crosshairs
}

# tabs.kak
bundle tabs.kak https://github.com/enricozb/tabs.kak.git %{
    map -docstring "tabs" global goto T "<esc>: enter-user-mode tabs<ret>"
    set-option global tabs_modelinefmt %{
        %val{cursor_line}:%val{cursor_char_column} {{context_info}} {{mode_info}} >>= %val{client}@[%val{session}] }
}

bundle-install-hook tabs.kak %{
    cargo install --locked --force --path .
}

# fzf.kak
bundle fzf.kak https://github.com/andreyorst/fzf.kak.git %{
    map -docstring "fzf-mode" global user f ": fzf-mode<ret>"
}

# kakoune-surround
bundle kakoune-surround https://github.com/h-youhei/kakoune-surround.git %{
    declare-user-mode surround
    # select to matching character
    unmap global normal m

    map global normal m ': enter-user-mode surround<ret>' -docstring 'surround'

    # map global surround m -docstring 'select to matching character' reactivate normal m binding?
    map global surround s ':surround<ret>' -docstring 'surround add'
    map global surround r ':change-surround<ret>' -docstring 'surround replace'
    map global surround d ':delete-surround<ret>' -docstring 'surround delete'
    map global surround t ':select-surrounding-tag<ret>' -docstring 'select tag'
}

# auto-pairs.kak
# 'disable-auto-pairs' or 'enable-auto-pairs'
bundle auto-pairs.kak https://github.com/alexherbo2/auto-pairs.kak.git %{
    enable-auto-pairs
}

# kakoune-lsp
bundle kakoune-lsp https://github.com/kakoune-lsp/kakoune-lsp.git %{
    map global user l %{: enter-user-mode lsp<ret>} -docstring "LSP mode"
    map global user k %{: lsp-hover<ret>} -docstring "LSP hover info"
    map global user a %{: lsp-code-actions<ret>} -docstring "LSP code action"
    map global user r %{: lsp-rename-prompt<ret>} -docstring "LSP rename"
    map global user s %{: lsp-workspace-symbol<ret>} -docstring "LSP show workspace symbols"

    lsp-inline-diagnostics-enable global

    lsp-inlay-hints-enable global

    # requires >= 2024
    lsp-inlay-code-lenses-enable global
    # requires >= 2024
    lsp-inlay-diagnostics-enable global

    hook global WinSetOption filetype=(rust|python|go|javascript|typescript|c|cpp|haskell) %{
        lsp-enable-window
    }
}

bundle-install-hook kakoune-lsp %{
    # optional: if you want to use specific language servers
    mkdir -p $HOME/.config/kak-lsp
    cp -n kak-lsp.toml $HOME/.config/kak-lsp/
}


# colorscheme loaded at the end because if not, the line colors from
# kak-crosshairs from the colorschemes are not loaded properly
colorscheme current-theme

########################################################
#                                                      #
#                 commented-out stuff                  #
#                                                      #
########################################################

# kakship - statusline
# bundle kakship https://git.itsufficient.me/rust/kakship.git %{
#     kakship-enable
# }

# bundle-install-hook kakship %{
#   cargo install --locked --force --path .
#   [ ! -e $kak_config/starship.toml ] && cp starship.toml $kak_config/
# }

# popup.kak (requires tmux, but not necessary for kak to run under tmux)
# bundle popup.kak https://github.com/enricozb/popup.kak.git %{
#     evaluate-commands %sh{kak-popup init}
# }

# bundle-install-hook popup.kak %{
#     cargo install --locked --force --path .
# }

