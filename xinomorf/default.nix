{ stubs
, pkgs ? import <nixpkgs> {} }:

{
  mkAutoScalingGroup = import ./autoscaling.nix { inherit pkgs; } stubs;
  mkS3Channel        = import ./s3-channel.nix  { inherit pkgs; } stubs;
}
