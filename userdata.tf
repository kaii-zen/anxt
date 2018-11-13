data "template_file" "userdata_nix" {
  template = "${file("${path.module}/userdata.nix")}"

  vars {
    class  = "${var.display_name}"
    family = "${local.pet_title}"
  }
}

module "userdata_nix" {
  source     = "./ec2-nixos-userdata"
  channels   = "${merge(var.nix_channels, local.channels)}"
  expression = "${data.template_file.userdata_nix.rendered}"
}
