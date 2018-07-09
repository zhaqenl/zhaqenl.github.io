with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "zhaqenl.github.io";
  buildInputs = [ gnumake parallel emem ];
}
