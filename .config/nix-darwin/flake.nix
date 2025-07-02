{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    helix-master.url = "github:helix-editor/helix/master";
    helix-master.inputs.nixpkgs.follows = "nixpkgs";

    btop-main.url = "github:aristocratos/btop";
    btop-main.flake = false;
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      btop-main,
      ...
    }:
    let
      user = "roger";
      darwinSystems = {
        mbair = "aarch64-darwin";
      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#mbair
      darwinConfigurations = nixpkgs.lib.attrsets.mapAttrs (
        systemName: hostPlatform:
        let
          specialArgs = {
            inherit
              inputs
              self
              user
              hostPlatform
              btop-main
              ;
          };
        in
        nix-darwin.lib.darwinSystem {
          system = systemName;
          inherit specialArgs;
          modules = [
            ./configuration.nix
            ./homebrew.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user} = import ./home-manager.nix;
            }
          ];
        }
      ) darwinSystems;

      # };
    };
}
