variable "subnet_ids" {
  type        = "list"
  description = "Subnet IDs for the autoscaling group"
}

variable "security_groups" {
  type        = "list"
  description = "Security group IDs for the austoscaling group"
}

variable "key_name" {
  type        = "string"
  description = "ssh key to use"
}

variable "s3_bucket" {
  type        = "string"
  description = "This is the S3 bucket in which we are going to store the currently active nix expression."
}

variable "s3_prefix" {
  type        = "string"
  description = "The prefix under which Nix expressions and other configuration-specific state data will be stored."
}
