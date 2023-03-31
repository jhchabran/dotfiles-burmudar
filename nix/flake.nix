{
  description = "William Flake config for his machines";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs";
      home-manager.url = "github:nix-community/home-manager";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
      darwin.url = "github:lnl7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "nixpkgs"; # ...
      flake-utils.url = "github:numtide/flake-utils";
      neovim-flake.url = "github:neovim/neovim?dir=contrib";
      neovim-flake.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, darwin, flake-utils, neovim-flake }:
  let
    # A function to return a customized pkgs per system which allowsUnfree
    user = "william";
    hosts = {
      desktop = "william-desktop";
      mac = "Williams-MacBook-Pro";
    };
    overlays = [
      (final: prev: {
        neovim-nightly-pkg = neovim-flake.packages.${prev.system};
      })
    ];
    pkgsForSystem = (system: (pkgsModule:
      let
        pkgs = import pkgsModule {
          inherit system;
          inherit overlays;
          config.allowUnfree = true;

        };
      in {
        inherit pkgs;
      }
    ));
  in {
      # using rec because otherwise we can't refer to the system var inside the set
      nixosConfigurations."${hosts.desktop}" = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.william = ./home.nix;
          }
        ];
        specialArgs = pkgsForSystem system nixpkgs;
      };
      darwinConfigurations."${hosts.mac}" = darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        modules = [
          ./hosts/mac/default.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.william = ./home.nix;
          }
        ];
        specialArgs = pkgsForSystem system nixpkgs;
      };
      homeConfigurations = {
        "desktop" = home-manager.lib.homeManagerConfiguration rec {
          pkgs = (pkgsForSystem "x86_64-linux" nixpkgs).pkgs;
          modules = [
            ./home.nix
            {
              home.homeDirectory = "/home/william";
            }
          ];
        };
        "mac" = home-manager.lib.homeManagerConfiguration rec {
          pkgs = (pkgsForSystem "aarch64-darwin" nixpkgs).pkgs;
          modules = [
            ./home.nix
            {
              home.homeDirectory = "/Users/william";
            }
          ];
        };
      };
  };
}
