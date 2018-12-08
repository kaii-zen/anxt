variable "count" {
  description = "Number of instances in the asg; this is going to be used for all min-, max-, and desired_capacity for the purpose of demonstration"
  default     = 1
}

variable "subnet_ids" {
  type        = "list"
  description = "Subnet IDs for the autoscaling group (required)"
}

variable "key_name" {
  type        = "string"
  description = "The SSH key that will be used for logging in (required)"
}

variable "security_groups" {
  type        = "list"
  description = "Security group IDs for the austoscaling group (required)"
}

variable "s3_bucket" {
  type        = "string"
  description = "This is the S3 bucket in which we are going to store the currently active nix expression. (required)"
}

variable "s3_prefix" {
  type        = "string"
  default     = "anxt"
  description = "The prefix under which Nix expressions and other configuration-specific state data will be stored. i.e., for the default value 'asg', expressions will be saved under asg/<config-id>/nixos/nixexprs.tar.xz"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "Instance type to use. Default is t2.micro"
}

variable "spot_price" {
  default = "1.00"
}
