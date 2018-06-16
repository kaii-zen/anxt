variable "nixos_release" {
  default = "18.03"
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

variable "cloudtrail_s3_bucket" {
  type = "string"
}
