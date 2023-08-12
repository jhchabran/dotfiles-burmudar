{
  description = "William Flake config for his machines";

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs"; # ...
    flake-utils.url = "github:numtide/flake-utils";
    # see: https://github.com/nix-community/neovim-nightly-overlay/issues/176
    neovim-nightly-overlay = { url = "github:neovim/neovim?dir=contrib"; inputs.nixpkgs.follows = "nixpkgs"; };
    # neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";

    cloudflare-caddy.url = "github:burmudar/nix-cloudflare-caddy";
    cloudflare-caddy.inputs.nixpkgs.follows = "nixpkgs";

    cloudflare-dns-ip.url = "github:burmudar/cloudflare-dns-ip";
    cloudflare-dns-ip.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, darwin, flake-utils, neovim-nightly-overlay, cloudflare-caddy, cloudflare-dns-ip }@inputs:
    let
      # generate pkgs for each subsystem ie. this results in the following set:
      # pkgs {
      #   x86_64-linux = <nixpkgs>;
      #   aarch64-darwin = <nixpkgs>;
      # }
      pkgs = (inputs.flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-linux" ] (system: {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ neovim-nightly-overlay.overlay cloudflare-caddy.overlay.default ];
          config = { allowUnfree = true; };
        };
      })).pkgs;
    in
    {
      nixosConfigurations.william-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { pkgs = pkgs.x86_64-linux; };
        modules = [
          ./hosts/desktop/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = false;
            home-manager.users.william = import ./home.nix;
          }
        ];
      };
      nixosConfigurations.media-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { pkgs = pkgs.x86_64-linux; };
        modules = [
          ./hosts/media/configuration.nix
          inputs.cloudflare-dns-ip.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = false;
            home-manager.users.william = import ./home.nix;
          }
        ];
      };
      darwinConfigurations.Williams-MacBook-Pro = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { pkgs = pkgs.aarch64-darwin; };
        modules = [
          ./hosts/mac/default.nix
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.william = import ./home.nix;
          }
        ];
      };
      homeConfigurations = {
        "desktop" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs.x86_64-linux;
          modules = [ ./home.nix { home.homeDirectory = "/home/william"; } ];
        };
        "mac" = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs.aarch64-darwin;
          modules = [ ./home.nix { home.homeDirectory = "/Users/william"; } ];
        };
      };
      formatter.x86_64-linux = pkgs.x86_64-linux.nixpkgs-fmt;
      formatter.aarch64-darwin = pkgs.aarch64-darwin.nixpkgs-fmt;
    };
}
