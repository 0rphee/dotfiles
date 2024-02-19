Using <https://www.atlassian.com/git/tutorials/dotfiles>, which is based on <https://news.ycombinator.com/item?id=11071754>

![vid](.config/hypr/preview/desk.mp4)

Remove shadow effect from screenshots.

```sh
defaults write com.apple.screencapture disable-shadow -bool true ; killall SystemUIServer
```

Install [oh-my-zsh](https://ohmyz.sh/) and [homebrew](https://brew.sh/).

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Get all installed [brew packages](.config/brew/brew_deps.txt).

```sh
brew ls --casks > ~/.config/brew/brew_deps.txt && brew leaves --installed-on-request >> ~/.config/brew/brew_deps.txt
```

Install all brew packages.

```sh
xargs brew install < ~/.config/brew/brew_deps.txt   
```

Link the helix runtime directory to the config directory.

```sh
ln -Fs ~/dev/rust/helix/runtime ~/.config/helix/runtime
```

Load [dark-mode-notify](https://github.com/bouk/dark-mode-notify) as a service.

```sh
launchctl load -w ~/Library/LaunchAgents/ke.bou.dark-mode-notify.plist

launchctl list | grep ke.bou
```

Remove the service

```sh
launchctl remove ke.bou.dark-mode-notify
```




