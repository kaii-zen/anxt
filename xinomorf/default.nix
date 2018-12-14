{ stubs
, pkgs ? import <nixpkgs> {} }:

{
  mkAnxtGroup   = import ./make-anxt-group.nix   { inherit pkgs; } stubs;
  mkAnxtChannel = import ./make-anxt-channel.nix { inherit pkgs; } stubs;
}
