# kakoune kks config
# export KKS_DEFAULT_SESSION="kak-global"
export KKS_USE_GITDIR_SESSIONS=1

export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="/Users/roger/.cargo/bin/hx"
export VISUAL=$EDITOR

# rust installations
. "$HOME/.cargo/env"

# haskell package bin installations from: stack install
export PATH="$HOME/.local/bin:$PATH"
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

# go installations
export PATH=$PATH:$HOME/go/bin
export GOPATH=$HOME/go;
export PATH=$PATH:$GOPATH/bin;

# homebrew installation, check .zprofile to see why it's here
eval "$(/opt/homebrew/bin/brew shellenv)"
