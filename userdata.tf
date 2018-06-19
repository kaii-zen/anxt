module "userdata_nix" {
  source     = "./ec2-nixos-userdata"
  channels   = "${merge(var.nix_channels, local.channels)}"
  expression = "${file("${path.module}/userdata.nix")}"
}
