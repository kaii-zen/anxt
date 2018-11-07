variable "nixos_release" {
  default = "18.09"
}

variable "display_name" {
  type = "string"
}

variable "s3_bucket" {
  type = "string"
}

variable "s3_prefix" {
  type    = "string"
  default = "asg"
}

variable "nixexprs" {
  default = ""
}

variable "nix_channels" {
  default     = {}
  description = "Extra Nix channels"
}
