{
  description = "William Flake config for his machines";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
      home-manager.url = "github:nix-community/home-manager";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
      darwin.url = "github:lnl7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "nixpkgs"; # ...
      flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, darwin, flake-utils }:
  let
    # A function to return a customized pkgs per system which allowsUnfree
    pkgsForSystem = (system:
      let
        pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [];
        };
      in {
        inherit pkgs;
      }
    );
  in {
      # using rec because otherwise we can't refer to the system var inside the set
      nixosConfigurations."william-desktop" = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          ./home.nix
        ];
        specialArgs = pkgsForSystem system;
      };
      darwinConfigurations."Williams-MacBook-Pro" = darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        modules = [
          ./hosts/mac/default.nix
          home-manager.darwinModules.home-manager
          ./home.nix
        ];
        specialArgs = pkgsForSystem system;
      };
  };
}
