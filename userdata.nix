{ lib, ... }:

{
  ec2.hvm = true;
  imports = [
    <nixos/nixos/modules/virtualisation/amazon-image.nix>
    <bootstrap/nixos/configuration.nix>
  ] ++ (lib.optional (builtins.pathExists ./user.nix) ./user.nix);
}
