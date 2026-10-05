{
  pkgs,
  self,
  inputs,
  hostPlatform,
  user,
  ...
}:
let
  helix = inputs.helix-master.packages.${hostPlatform}.default;
in
{
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  # public binary caches only (no auth needed); cache.nixos.org stays as default
  nix.settings.extra-substituters = [
    "https://nix-community.cachix.org"
    "https://cache.iog.io"
    "https://helix.cachix.org"
  ];
  nix.settings.extra-trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
  ];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 60d";
  };
  nix.optimise.automatic = true;

  nix.extraOptions = ''
    always-allow-substitutes = true
    extra-nix-path = nixpkgs=flake:nixpkgs
  '';

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = hostPlatform;

  system.primaryUser = "or";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  system.defaults = {
    # see more
    # https://github.com/yannbertrand/macos-defaults
    # https://github.com/ryan4yin/nix-darwin-kickstarter/blob/main/rich-demo/modules/system.nix

    controlcenter = {
      BatteryShowPercentage = true;
      Bluetooth = true;
    };

    dock = {
      autohide = true;
      mru-spaces = false; # mru-spaces: rearrange spaces on the most recent use
      orientation = "left";
      wvous-tr-corner = 10; # 10: Put Display to Sleep
      wvous-br-corner = 4; # 4: Show Desktop
      expose-animation-duration = 0.0;
      autohide-time-modifier = 0.5;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXPreferredViewStyle = "clmv"; # column view in finder
      ShowPathbar = true;
      _FXShowPosixPathInTitle = true;
    };

    trackpad = {
      TrackpadFourFingerHorizSwipeGesture = 2;
      Clicking = true;
      FirstClickThreshold = 2;
      Dragging = true;
      TrackpadThreeFingerDrag = true;
      TrackpadThreeFingerTapGesture = 2;
    };

    menuExtraClock.Show24Hour = true;

    NSGlobalDomain."com.apple.trackpad.scaling" = 3.0;

    screencapture = {
      location = "~/Desktop";
      disable-shadow = true;
    };

    loginwindow.LoginwindowText = "waaaa";

    CustomUserPreferences = {
      "wang.jianing.app.OpenInEditor-Lite" = {
        LiteDefaultEditor = "neovim";
        NeovimCommand = "open -na kitty --args --single-instance /run/current-system/sw/bin/hx PATH";
      };
      "wang.jianing.app.OpenInTerminal-Lite" = {
        LiteDefaultTerminal = "kitty";
        KittyCommand = "open -na kitty --args --single-instance --directory";
      };
    };
  };

  # sudo with Touch ID
  security.pam.services.sudo_local.touchIdAuth = true;

  networking = rec {
    # sudo scutil --set
    computerName = "lamak"; # ComputerName
    hostName = computerName; # HostName
    localHostName = computerName; # LocalHostName
  };

  environment.variables = rec {
    EDITOR = "${helix}/bin/hx"; # full path: PATH may not be set when EDITOR is invoked
    VISUAL = EDITOR;
    GREP_COLOR = "auto";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    # nix
    pkgs.nil
    pkgs.nixfmt

    pkgs.git
    pkgs.bat
    pkgs.btop
    pkgs.fastfetch
    pkgs.delta
    pkgs.lazydocker
    pkgs.lazygit
    pkgs.ripgrep
    pkgs.tree

    pkgs.python314 # pinned minor version, bump manually

    helix
  ];

  fonts.packages = [
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.mononoki
    pkgs.nerd-fonts.symbols-only
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableFastSyntaxHighlighting = true;
    interactiveShellInit = ''
      source "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
      source "${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
      source "${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh"

      # if a path is not a command, cd into it
      setopt auto_cd
      alias -g ...='../..'
      alias -g ....='../../..'
      alias -g .....='../../../..'
      alias -g ......='../../../../..'

      alias ls="ls -G"
      alias l="ls -Glah"
      alias ll="ls -Glh"
      alias la="ls -GlAh"
      alias kssh="kitten ssh"

      fastfetch -c ${./fastfetch.jsonc}
    '';
    promptInit = ''
      source "${pkgs.spaceship-prompt}/lib/spaceship-prompt/spaceship.zsh"
    '';
  };

  power = {
    sleep = {
      computer = 10;
      display = 5;
    };
  };

  # See more: https://daiderd.com/nix-darwin/manual/index.html#opt-services.yabai.enable
  services.yabai = {
    enable = false; # service installed manually (yabai --install-service; yabai --start-service), due to differences in the launchd.plist file. GH issue: https://github.com/LnL7/nix-darwin/issues/1226
  };

  users.users.${user} = {
    home = "/Users/${user}";
    shell = pkgs.zsh;
  };

}
