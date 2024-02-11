Using https://www.atlassian.com/git/tutorials/dotfiles which is based on https://news.ycombinator.com/item?id=11071754

![vid](.config/hypr/preview/desk.mp4)

Remove shadow effect from screenshots.

```sh
defaults write com.apple.screencapture disable-shadow -bool true ; killall SystemUIServer
```

Get all installed brew packages.

```sh
brew ls --casks > ~/.config/brew/brew_deps.txt && brew leaves --installed-on-request >> ~/.config/brew/brew_deps.txt
```

Install all brew packages.

```sh
xargs brew install < ~/.config/brew/brew_deps.txt   
```




![](.config/brew/brew_deps.txt)

