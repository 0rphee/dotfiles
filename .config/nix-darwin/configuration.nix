{
  pkgs,
  self,
  inputs,
  hostPlatform,
  user,
  ...
}:
{
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.substituters = [
    "https://cache.nixos.org/"
    "https://cache.iog.io"
    "https://nix-community.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  nix.extraOptions = ''
    always-allow-substitutes = true
    extra-nix-path = nixpkgs=flake:nixpkgs
    upgrade-nix-store-path-url = https://install.determinate.systems/nix-upgrade/stable/universal
  '';

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = hostPlatform;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  system.defaults = {
    # see more
    # https://github.com/yannbertrand/macos-defaults
    # https://github.com/ryan4yin/nix-darwin-kickstarter/blob/main/rich-demo/modules/system.nix

    dock = {
      autohide = true;
      mru-spaces = false; # mru-spaces: rearrange spaces on the most recent use
      orientation = "left";
      wvous-tr-corner = 10; # 10: Put Display to Sleep
      wvous-br-corner = 4; # 4: Desktop
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXPreferredViewStyle = "clmv"; # column view in finder
      ShowPathbar = true;
      _FXShowPosixPathInTitle = true;
    };

    screencapture = {
      location = "~/Desktop";
      disable-shadow = true;
    };

    loginwindow.LoginwindowText = "waaaa";
  };

  security.pam.enableSudoTouchIdAuth = true;

  environment.variables = rec {
    EDITOR = "${inputs.helix-master.packages.${hostPlatform}.default}/bin/hx";
    VISUAL = EDITOR;
    GREP_COLOR = "auto";
  };

  environment.extraInit = '''';
  environment.shellAliases = {
    # not loaded in nix develop
    # ls = "ls -G";
    # lsa = "ls -Glah";
    # l = "ls -Glah";
    # ll = "ls -Glh";
    # la = "ls -GlAh";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    # nix
    pkgs.nil
    pkgs.nixfmt-rfc-style

    pkgs.git
    pkgs.bat
    pkgs.btop
    pkgs.delta
    pkgs.lazydocker
    pkgs.lazygit
    pkgs.ripgrep
    pkgs.starship
    pkgs.tree

    pkgs.zsh
    pkgs.zoxide
    pkgs.spaceship-prompt
    pkgs.zsh-autosuggestions
    pkgs.zsh-vi-mode
    pkgs.zsh-nix-shell

    pkgs.python312Full

    inputs.helix-master.packages.${hostPlatform}.default
  ];

  programs.zsh = {
    interactiveShellInit = ''
      source "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
      source "${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
      source "${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh"
      source "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh"

      # if a path is not a command, cd into it
      setopt auto_cd
      alias -g ...='../..'
      alias -g ....='../../..'
      alias -g .....='../../../..'
      alias -g ......='../../../../..'

      alias ls="ls -G";
      alias lsa="ls -Glah";
      alias l="ls -Glah";
      alias ll="ls -Glh";
      alias la="ls -GlAh";
    '';
    loginShellInit = '''';
    promptInit = ''
      source "${pkgs.spaceship-prompt}/lib/spaceship-prompt/spaceship.zsh"
    '';
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
