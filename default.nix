{ stubs
, pkgs ? import <nixpkgs> {} }:

{
  xinomorf = import ./xinomorf { inherit pkgs stubs; };
}
