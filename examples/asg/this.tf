# Create an SSM parameter to be used from the NixOS configuration. (see ./nix/nixos/configuration.nix)
resource "aws_ssm_parameter" "this" {
  name  = "${module.this.ssm_path}/motd"
  type  = "String"
  value = "Hello, world!"
}

module "this" {
  source        = "../.."
  display_name  = "ASG Test"
  nixos_release = "18.09"
  s3_bucket     = "${var.s3_bucket}"
  nixexprs      = "${path.module}/nix"
}
