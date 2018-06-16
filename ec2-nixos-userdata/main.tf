variable "channels" {
  default = {
    nixos = "http://nixos.org/channels/nixos-18.03"
  }
}

variable "expression" {
  default = "{}"
}

locals {
  channels = "${join("", formatlist("### %v %v\n", values(var.channels), keys(var.channels)))}"
}

data "template_file" "this" {
  template = "${file("${path.module}/userdata.nix.tpl")}"

  vars = {
    channels   = "${local.channels}"
    expression = "${var.expression}"
  }
}

output "rendered" {
  description = "The userdata that should be passed to the instance/launch configuration/template in order to evaluate `expression` with all `channels` available."
  value       = "${data.template_file.this.rendered}"
}
