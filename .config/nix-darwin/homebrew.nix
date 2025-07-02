{ ... }:
{
  # To make this work, homebrew need to be installed manually, see https://brew.sh
  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      # "zap" removes manually installed brews and casks (and related files) not listed in the generated Brewfile
      # "none" formulae not present in the generated Brewfile are left installed.
      # "uninstall" This uninstalls all formulae not listed in generated Brewfile, i.e., brew uninstall is run for those formulae.
      cleanup = "none";
      autoUpdate = false; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = false; # Upgrade outdated casks, formulae, and App Store apps
    };

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas
    # will not be uninstalled when removed
    masApps = {
      # Xcode = 497799835;
    };

    # `brew install`
    brews = [
    ];

    # `brew install --cask`
    casks = [
      # "utm"
      "docker" # docker desktop
      "firefox"
      "handbrake"
      "steam"
      "raycast"
      "zoom"
      "openinterminal-lite"
      "openineditor-lite"
      "launchcontrol"
      "chromium"
      "obsidian"
      "steam"
      "altserver"
      # "bitwarden" installed via app store

      "font-comic-mono"
      "font-iosevka"
      "font-mononoki"
      "font-symbols-only-nerd-font"
    ];
    taps = [
      "homebrew/bundle"
    ];
  };
}
