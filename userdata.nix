{ lib, ... }:

{
  ec2.hvm = true;
  anxt = {
    class  = "${class}";
    family = "${family}";
  };
  imports = [
    <nixos/nixos/modules/virtualisation/amazon-image.nix>
    <bootstrap/nixos/configuration.nix>
  ] ++ (lib.optional (builtins.pathExists ./user.nix) ./user.nix);
}
