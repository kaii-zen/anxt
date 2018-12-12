stubs:

let
  pkgs = import <nixpkgs> {};
  anxt = ../..;

  inherit ((import anxt { inherit pkgs stubs; }).xinomorf) mkAnxtGroup;

in mkAnxtGroup {
  displayName = "Xinomorf Anxt Example";
  nixosConfig = ./nixos;
  s3Bucket    = "\${var.s3_bucket}";
  keyName     = "\${aws_key_pair.this.key_name}";
}
