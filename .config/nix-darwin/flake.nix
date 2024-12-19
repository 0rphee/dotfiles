{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    helix-master.url = "github:helix-editor/helix/master";
    helix-master.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      configuration =
        { pkgs, ... }:
        rec {
          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";
          nix.settings.substituters = [
            "https://cache.nixos.org/"
            "https://cache.iog.io"
          ];
          nix.settings.trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
          ];

          nix.extraOptions = ''
            always-allow-substitutes = true
            extra-nix-path = nixpkgs=flake:nixpkgs
            upgrade-nix-store-path-url = https://install.determinate.systems/nix-upgrade/stable/universal
          '';

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          system.defaults = {
            dock.autohide = true;
            dock.mru-spaces = false; # mru-spaces: rearrange spaces on the most recent use
            finder.AppleShowAllExtensions = true;
            finder.FXPreferredViewStyle = "clmv"; # column view in finder
            loginwindow.LoginwindowText = "waaaa";
            screencapture.location = "~/Desktop";
          };

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          users.users.roger = {
            home = "/Users/roger";
            name = "roger";
          };

          security.pam.enableSudoTouchIdAuth = true;

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            # nix
            pkgs.nil
            pkgs.nixfmt-rfc-style

            pkgs.kitty
            pkgs.git
            pkgs.bat
            pkgs.btop
            pkgs.delta
            pkgs.lazydocker
            pkgs.lazygit
            pkgs.ripgrep
            pkgs.starship
            pkgs.tree
            pkgs.tinymist # typst lsp
            pkgs.typst
            pkgs.yaml-language-server

            pkgs.zsh
            pkgs.zoxide
            pkgs.spaceship-prompt
            pkgs.zsh-autosuggestions
            pkgs.zsh-vi-mode
            pkgs.zsh-nix-shell

            # see service note below
            pkgs.yabai
            pkgs.skhd

            pkgs.python312Full

            inputs.helix-master.packages.${nixpkgs.hostPlatform}.default
          ];

          programs.zsh = {
            # zsh-fast-syntax-highlighting
            # enableFastSyntaxHighlighting = true; doesn't work?
            # /etc/zshrc:source:28: no such file or directory: /nix/store/jwzqy4m1amkqk0yp2a6s1z278s6psrvw-zsh-fast-syntax-highlighting-1.55/share/zsh-fast-syntax-highlighting/zsh-fast-syntax-highlighting.zsh

            # zsh-syntax-highlighting
            enableSyntaxHighlighting = false;
            interactiveShellInit = ''
              source "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
              source "${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
              source "${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh"
              source "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh"
            '';
            loginShellInit = '''';
            promptInit = ''
              source "${pkgs.spaceship-prompt}/lib/spaceship-prompt/spaceship.zsh"
            '';
          };

          # See more: https://daiderd.com/nix-darwin/manual/index.html#opt-services.yabai.enable
          services.yabai = {
            enable = false; # service installed manually (yabai --install-service; yabai --start-service), due to differences in the launchd.plist file. GH issue: https://github.com/LnL7/nix-darwin/issues/1226
            enableScriptingAddition = false;
            package = pkgs.yabai;
            config = { };
            extraConfig = "";
          };
          # if a path is not a command, cd into it
          environment.extraInit = ''
            setopt auto_cd
            alias -g ...='../..'
            alias -g ....='../../..'
            alias -g .....='../../../..'
            alias -g ......='../../../../..'
          '';
          environment.variables = rec {
            EDITOR = "${inputs.helix-master.packages.${nixpkgs.hostPlatform}.default}/bin/hx";
            VISUAL = EDITOR;
          };
          environment.shellAliases = {
            ls = "ls -G";
            lsa = "ls -Glah";
            l = "ls -Glah";
            ll = "ls -Glh";
            la = "ls -GlAh";
          };
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#mbair
      darwinConfigurations."mbair" = nix-darwin.lib.darwinSystem {
        system = configuration.nixpkgs.hostPlatform;
        specialArgs = { inherit inputs; };
        modules = [
          configuration
          ./homebrew.nix

          inputs.home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.roger = import ./home-manager.nix;
          }
        ];
      };
    };
}
