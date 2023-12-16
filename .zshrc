# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

ZSH_THEME="my-dash-passion"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.

ZSH_THEME_RANDOM_CANDIDATES=( 
  "blinks"
  "candy"
  "clean"
  "dallas"
  "dieter"
  "dst"              	#topp
  "jonathan"
  "jtriley"
  "philips"
  "passion" 		      #topp
  "my-dash-passion"
  "headline"		#topp
  "oh-my-via/via"	#topp
)

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  stack
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"



############# MY PREVIOUS CONFIG ############# without conda
# check ~/.zprofile, ~/.zshenv, and /etc/paths.d/ for directories added to $PATH
# order of sourcing: https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout
# .zshenv -> .zprofile -> .zshrc -> .zlogin -> .zlogout

LFCD="$HOME/.config/lf/lfcd.sh"                                #  pre-built binary, make sure to use absolute path

export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="/Users/roger/.cargo/bin/hx"
export VISUAL=$EDITOR

# needed for compiling with ghc (theres no ghc backend for ARM code-gen, the compiler uses llvm (well, supposedly there's native code-gen since 9.2.1)
# export PATH="/opt/homebrew/opt/llvm@12/bin:$PATH"
# export LDFLAGS="-L/opt/homebrew/opt/llvm@12/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/llvm@12/include"

# haskell package bin installations from: $ stack install
export PATH="/Users/roger/.local/bin:$PATH" 

# alias for opening all helix config files for helix
alias cfh="hx ~/.config/helix/config.toml ~/.config/helix/languages.toml ~/.config/helix/themes/my-gruvbox.toml ~/.config/helix/themes/my-gruvbox-light.toml ~/.config/helix/themes/my-noctis.toml"

# config for pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# git access to dotfles
alias config='/usr/bin/git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME'

LFCD="$HOME/.config/lf/lfcd.sh"                                #  pre-built binary, make sure to use absolute path
if [ -f "$LFCD" ]; then
    source "$LFCD"
fi

# helix project picker
alias fhx=". $XDG_CONFIG_HOME/helix/hxscript.zsh"

# zellij setup --generate-auto-start zsh
# if [[ -z "$ZELLIJ" ]]; then
#     if [[ "$ZELLIJ_AUTO_ATTACH" == "true" ]]; then
#         zellij attach -c
#     else
#         zellij
#     fi

#     if [[ "$ZELLIJ_AUTO_EXIT" == "true" ]]; then
#         exit
#     fi
# fi

# echo "Mamma Mia!" | figlet -f "alligator" | lolcat
echo "Mamma Mia!" | figlet -f "slant" | lolcat
# echo "Mamma Mia!" | figlet -f "3D-ASCII" | lolcat
# echo "Mamma Mia!" | figlet -f "ANSI Shadow" | lolcat


[ -f "/Users/roger/.ghcup/env" ] && source "/Users/roger/.ghcup/env" # ghcup-env

# add brew completions
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
