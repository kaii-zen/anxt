module "this" {
  source               = "../"
  display_name         = "SSM NixOS Test"
  nixos_release        = "18.03"
  cloudtrail_s3_bucket = "${var.cloudtrail_s3_bucket}"
  s3_bucket            = "${var.s3_bucket}"
  s3_prefix            = "${var.s3_prefix}"
  nixexprs             = "${path.module}/nixos"
}
