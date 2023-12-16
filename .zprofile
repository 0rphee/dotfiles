# I suppose, this is the brew setup for the shell?
# 16.12.2023 the paths from /private/etc/paths are loaded before this
eval "$(/opt/homebrew/bin/brew shellenv)"

# this seems to add three times 
          # /Users/roger/.local/bin
          # /Users/roger/.cabal/bin:
          # /Users/roger/.ghcup/bin:
          # /opt/homebrew/opt/llvm@12/bin:
# export PATH
