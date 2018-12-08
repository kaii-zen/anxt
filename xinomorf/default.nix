{ stubs
, pkgs ? import <nixpkgs> {} }:

{
  mkAnxtGroup = import ./make-anxt-group.nix { inherit pkgs; } stubs;
}
