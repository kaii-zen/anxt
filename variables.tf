variable "nixos_release" {
  default = "18.09"
}

variable "display_name" {
  type = "string"
}

variable "s3_bucket" {
  type = "string"
}

variable "prefix" {
  type    = "string"
  default = "anxt"
}

variable "nixexprs" {
  default = ""
}

variable "nix_channels" {
  default     = {}
  description = "Extra Nix channels"
}
