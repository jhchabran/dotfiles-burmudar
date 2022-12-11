{
  description = "neovim flake with telescope";

  inputs = {
          neovim.url = "https://github.com/neovim/neovim/blob/master/contrib/flake.nix";
          neovim.follows = "nixpkgs";
          telescope-fzf = {
              type = "github";
              owner = "nvim-telescope";
              repo = "telescope-fzf-native.nvim";
              flake = false;
          };
      };

  outputs = { self, nixpkgs, neovim, telescope-fzf }:
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs { system = system; };
        examiner = (with pkgs; stdenv.mkDerivation {
            name = "examiner";
            version = "dev";
            src = fetchFromGitHub {
                owner = "Conni2461";
                repo = "examiner";
                rev = "4fa86cbc61773885cd395418ed6ba2da8ebc5483";
                hash = "sha256-r8z94lGF3J6i9UrjS/iuSGzVGVLDI4BVurOjH2/P/w4=";
            };
            nativeBuildInputs = [ pkg-config ];
            doCheck = true;
            checkTarget = "test";
            makeFlags = [ "PREFIX=$(out)" ];
        });
        luaPkg = pkgs: mylua:
            with mylua.pkgs; with pkgs; buildLuaPackage {
                pname = "telescope-fzf-native.nvim";
                version = "0.0.0";
                src = fetchFromGitHub {
                    owner = "nvim-telescope";
                    repo = "telescope-fzf-native.nvim";
                    rev = "65c0ee3d4bb9cb696e262bca1ea5e9af3938fc90";
                    sha256 = "hdQuS7AcvN5vIXBJnSwFsuyvX89+XDrSsea9TBWF21s=";
                };

                nativeBuildInputs = [ makeWrapper pkg-config examiner];
                
                buildPhase = "make";
                installPhase = ''
                    mkdir -p "$out/share/lua/${mylua.luaversion}/telescope/_extensions/"
                    cp build/libfzf.so "$out/share/lua/${mylua.luaversion}/telescope/_extensions/fzf.so"
                '';
                doCheck = true;
                checkTarget = "test";
                makeFlags = [ "PREFIX=$(out)" ];
            };
        neovim-unwrapped = neovim.packages.${system}.package
        nvim = pkgs.wrapNeovim neovim-unwrapped {
            configure = {
                customRc = ''
                luaFile ~/.config/nvim/init.lua
                '';
                };
            };

    in rec {
        inherit system;

        packages.${system} = {
            telescope-fzf = luaPkg pkgs pkgs.neovim-unwrapped.lua;
        };

        defaultPackage.


        defaultApp = {
            type = "app";
            program = "${nvim)/bin/nvim";
        };
            

    };
}
