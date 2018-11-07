# Create an SSM parameter to be used from the NixOS configuration. (see ./nix/nixos/configuration.nix)
resource "aws_ssm_parameter" "this" {
  name  = "motd"
  type  = "SecureString"
  value = "Hello, world!"
}

module "this" {
  source        = "../"
  display_name  = "SSM NixOS Test"
  nixos_release = "18.09"
  s3_bucket     = "${var.s3_bucket}"
  s3_prefix     = "${var.s3_prefix}"
  nixexprs      = "${path.module}/nix"
}
