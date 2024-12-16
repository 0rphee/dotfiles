{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    helix-master.url = "github:helix-editor/helix/master";
    helix-master.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      ...
    }:
    let
      configuration =
        { pkgs, ... }:
        rec {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [

            # nix
            pkgs.nil
            pkgs.nixfmt-rfc-style

            pkgs.git

            inputs.helix-master.packages.${nixpkgs.hostPlatform}.default
          ];

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

          security.pam.enableSudoTouchIdAuth = true;
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#mbair
      darwinConfigurations."mbair" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          ./homebrew.nix
        ];
      };
    };
}
