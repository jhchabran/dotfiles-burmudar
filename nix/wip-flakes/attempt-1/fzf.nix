{ luajit, fetchFromGitHub, stdenv, pkgs, makeWrapper }:

let
    inherit (luajit.pkgs) lua buildLuaPackage;
in buildLuaPackage {
    pname = "telescope-fzf-native.nvim";
    version = "0.0.0";
    src = fetchFromGitHub {
        owner = "nvim-telescope";
        repo = "telescope-fzf-native.nvim";
        rev = "65c0ee3d4bb9cb696e262bca1ea5e9af3938fc90";
        sha256 = "hdQuS7AcvN5vIXBJnSwFsuyvX89+XDrSsea9TBWF21s=";
    };

    nativeBuildInputs = [ makeWrapper ];
    
    buildPhase = "make";
    installPhase = ''
        mkdir -p "$out/share/lua/${lua.luaversion}/telescope/_extensions/"
        cp build/libfzf.so "$out/share/lua/${lua.luaversion}/telescope/_extensions/fzf.so"
    '';
}

#stdenv.mkDerivation {
#    name = "telescope-fzf-native";
#    src = pkgs.fetchgit {
#        url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim";
#        rev = "65c0ee3d4bb9cb696e262bca1ea5e9af3938fc90";
#        sha256 = "hdQuS7AcvN5vIXBJnSwFsuyvX89+XDrSsea9TBWF21s=";
#    };
#
#    buildPhase = "make";
#    installPhase = ''
#    mkdir -p $out/bin
#    cp build/libfzf.so $out/bin
#    '';
#}
