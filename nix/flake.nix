{
  description = "William Flake config for his machines";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
      home-manager.url = "github:nix-community/home-manager";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
      darwin.url = "github:lnl7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "nixpkgs"; # ...
  };

  outputs = { self, nixpkgs, home-manager, darwin }:
  let
    # define variables here
  in {
      nixosConfigurations."william-desktop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop/default.nix
          home-manager.nixosModules.home-manager
          ./home.nix
        ];
      };
      darwinConfigurations."Williams-MacBook-Pro" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/mac/default.nix
          home-manager.darwinModules.home-manager
          ./home.nix
        ];
      };
    };

}
