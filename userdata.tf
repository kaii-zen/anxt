module "userdata_nix" {
  source = "./ec2-nixos-userdata"

  channels = {
    nixos     = "http://nixos.org/channels/nixos-${var.nixos_release}"
    bootstrap = "s3://${var.s3_bucket}/${local.bootstrap_nix_key}"
    user      = "s3://${var.s3_bucket}/${local.user_nix_key}"
  }

  expression = "${file("${path.module}/userdata.nix")}"
}
