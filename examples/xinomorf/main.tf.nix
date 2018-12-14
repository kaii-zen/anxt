stubs:

let
  pkgs = import <nixpkgs> {};
  inherit (import ../.. { inherit pkgs stubs; }) mkAutoScalingGroup mkS3Channel;

in mkAutoScalingGroup {
  displayName    = "Xinomorf Anxt Example";
  nixosConfig    = ./nixos;
  s3Bucket       = "\${var.s3_bucket}";
  s3Prefix       = "\${var.s3_prefix}";
  keyName        = "\${var.key_name}";
  securityGroups = [ "\${var.security_groups}" ];
  subnetIds      = [ "\${var.subnet_ids}" ];
}
