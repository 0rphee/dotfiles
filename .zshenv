export XDG_CONFIG_HOME="$HOME/.config"

# rust installations
. "$HOME/.cargo/env"

# haskell package bin installations from: stack install
export PATH="$HOME/.local/bin:$PATH"
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

# homebrew installation, check .zprofile to see why it's here
eval "$(/opt/homebrew/bin/brew shellenv)"
