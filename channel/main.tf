# TODO: Remove this?
variable "name" {
  type        = "string"
  description = "This is used in the derivation name; i.e., <name>-channel.tar.xz"
}

variable "nixexprs" {
  type        = "string"
  description = "Path to the Nix expressions"
}

variable "binary-cache-url" {
  default     = ""
  type        = "string"
  description = "This can be used to point to a binary cache; theoretical use case being that an instance could push its system closure to a binary cache for use by future instances of the same config."
}

locals {
  external_cmd = [
    "${path.module}/nix-build-wrapper",
    "${path.module}",
    "${var.name}",
    "${var.nixexprs}",
    "${var.binary-cache-url}",
  ]
}

data "external" "channel" {
  program = "${compact(local.external_cmd)}"
}

output "path" {
  value       = "${data.external.channel.result.path}"
  description = "Path to the generated tarball in the Nix store"
}

# TODO: Remove?
output "name" {
  value       = "${var.name}"
  description = "Name passthru"
}
