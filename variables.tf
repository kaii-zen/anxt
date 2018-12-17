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

variable "extra_s3_channels" {
  default     = {}
  description = "Extra Nix channels on S3; these must be paths paths under the same bucket and prefix specified by the s3_bucket and prefix variables respectively"
}
