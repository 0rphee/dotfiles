Using the git setup explained here: <https://www.atlassian.com/git/tutorials/dotfiles>, which is based on <https://news.ycombinator.com/item?id=11071754>

![vid](.config/hypr/preview/desk.mp4)

Dotfiles for macos, managed partially by nix ([.config/nix-darwin)](.config/nix-darwin)), whith the remnants of an asahi-linux-fedora-remix setup.

```sh
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake "$HOME/.config/nix-darwin"
```

```sh
sudo darwin-rebuild switch --flake "$HOME/.config/nix-darwin"
```
