# Create an SSM parameter to be used from the NixOS configuration. (see ./nix/nixos/motd.nix)
resource "aws_ssm_parameter" "this_motd" {
  name  = "${module.this.ssm_path}/motd"
  type  = "String"
  value = "Hello, world!"
}
