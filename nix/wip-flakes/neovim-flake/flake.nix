{
    inputs = {
          neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
          neovim.url = "https://github.com/neovim/neovim/blob/master/contrib/flake.nix";
          neovim.follows = "nixpkgs";
          flake-utils.url = "github:numtide/flake-utils";
    };
    outputs = { self, nixpkgs, neovim-nightly-overlay, neovim, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
        let
            system = "x86_64-linux";
            #pkgs = import nixpkgs { inherit system; overlays = [ neovim-nightly-overlay.overlay ]; };
            pkgs = import nixpkgs { inherit system; };

            
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

            fzfLuaPkg = luaPkg pkgs pkgs.neovim-unwrapped.lua;

            config = pkgs.neovimUtils.makeNeovimConfig {
                customRc = "luafile ~/.config/nvim/init.lua";
                extraLuaPackages = (ps: with ps;  [ fzfLuaPkg ]);
            };

            nvimPkg = with pkgs; (wrapNeovim neovim-unwrapped.overrideAttrs {
                inherit config;
            });

            nvimApp = flake-utils.lib.mkApp {
                drv = nvimPkg;
                exePath = "/bin/nvim";
            };
        in
        {
            inherit system;
            fzf.${system} = fzfLuaPkg;
            inherit config;
            #defaultPackage.${system} = pkgs.neovim.override {
                #configure = {
                    #customRc = ''luafile ~/.config/nvim/init.lua'';
                #};
            #};

            defaultPackage = nvimPkg;
            defaultApp = nvimApp;

            devShell = pkgs.mkShell {
                buildInputs = [
                    nvimPkg
                    ];
                    };




        });
}
