# I suppose, this is the brew setup for the shell?
# 16.12.2023 the paths from /private/etc/paths are loaded before this
# 
# 15.12.2023 moved the command to .zshenv because it wasn't being used by the launchd skhd daemon after installing nix-darwin
# eval "$(/opt/homebrew/bin/brew shellenv)"

# this seems to add three times 
          # /Users/roger/.local/bin
          # /Users/roger/.cabal/bin:
          # /Users/roger/.ghcup/bin:
          # /opt/homebrew/opt/llvm@12/bin:
# export PATH
