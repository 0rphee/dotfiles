Using <https://www.atlassian.com/git/tutorials/dotfiles>, which is based on <https://news.ycombinator.com/item?id=11071754>

![vid](.config/hypr/preview/desk.mp4)

Remove shadow effect from screenshots.

```sh
defaults write com.apple.screencapture disable-shadow -bool true ; killall SystemUIServer
```

Get all installed [brew packages](.config/brew/brew_deps.txt).

```sh
brew ls --casks > ~/.config/brew/brew_deps.txt && brew leaves --installed-on-request >> ~/.config/brew/brew_deps.txt
```

Install all brew packages.

```sh
xargs brew install < ~/.config/brew/brew_deps.txt   
```

Install [oh-my-zsh](https://ohmyz.sh/).
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
