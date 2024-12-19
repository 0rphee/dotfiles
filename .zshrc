# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# ZSH_THEME="daivasmara"
# ZSH_THEME="my-dash-passion"
ZSH_THEME=""

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
  "dst"
  "jonathan"
  "jtriley"
  "philips"
  "passion"
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
  stack
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-vi-mode # https://github.com/jeffreytse/zsh-vi-mode
  nix-shell
)

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#849289" #,bg=cyan,bold,underline"

# NOW MANAGED IN nix-darwin
# source $ZSH/oh-my-zsh.sh

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

# needed for compiling with ghc (theres no ghc backend for ARM code-gen, the compiler uses llvm (well, supposedly there's native code-gen since 9.2.1)
# export PATH="/opt/homebrew/opt/llvm@12/bin:$PATH"
# export LDFLAGS="-L/opt/homebrew/opt/llvm@12/lib"
# export CPPFLAGS="-I/opt/homebrew/opt/llvm@12/include"

# git access to dotfles
alias config='git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME'

alias configlg='lazygit --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME'

alias lg=lazygit

# echo "Mamma Mia!" | figlet -f "alligator" | lolcat
# "slant"
# "3D-ASCII"
# "ANSI Shadow"

# ncurses https://stackoverflow.com/questions/63730439/lib64-libtinfo-so-5-no-version-information-available
# issue when compiling Haskeline (found to interfere with more programs also) /lib64/libtinfo.so.6: no version information available
# possibly also adding to configure --with-shared?
# ./configure --prefix=$HOME/opt/ncurses --with-versioned-syms --with-termlib
# sudo make
# sudo make install
# export LD_LIBRARY_PATH="$HOME/opt/ncurses/lib:$LD_LIBRARY_PATH"

eval "$(zoxide init zsh --cmd cd)"

# prompt MOVED to nix-darwin flake
# eval "$(starship init zsh)"
# source "/nix/store/pad214p2pck4r3bm3qd0dc2k67lgva8f-spaceship-prompt-4.17.0/lib/spaceship-prompt/spaceship.zsh"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
