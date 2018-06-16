variable "name" {
  type = "string"
}

variable "nixexprs" {
  type = "string"
}

variable "binary-cache-url" {
  default = ""
  type    = "string"
}

locals {
  external_cmd = [
    "${path.module}/nix-build-wrapper",
    "${path.module}/channel.nix",
    "${var.name}",
    "${var.nixexprs}",
    "${var.binary-cache-url}",
  ]
}

data "external" "channel" {
  program = "${compact(local.external_cmd)}"
}

output "path" {
  value = "${data.external.channel.result.path}"
}

output "name" {
  value = "${var.name}"
}
