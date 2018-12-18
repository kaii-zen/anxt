module "this" {
  source        = "../"
  display_name  = "Test"
  nixos_release = "18.09"
  s3_bucket     = "${var.s3_bucket}"
  prefix        = "${var.s3_prefix}"
  nixexprs      = "${path.module}/nix"

  extra_s3_channels = {
    users = "${local.test_user_channel_key}"
  }
}
