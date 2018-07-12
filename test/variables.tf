variable "count" {
  description = "Number of instances in the asg"
  default     = 1
}

variable "subnet_ids" {
  type        = "list"
  description = "Subnet IDs for the autoscaling group"
}

variable "security_groups" {
  type        = "list"
  description = "Security group IDs for the austoscaling group"
}

variable "cloudtrail_s3_bucket" {
  type        = "string"
  description = "Name of an S3 bucket to use with cloudtrail. We must setup a cloudtrail for cloudwatch to be able to intercept individual S3 PUT events. Please refer to AWS documentation for the correct permissions."
}

variable "s3_bucket" {
  type        = "string"
  description = "This is the S3 bucket in which we are going to store the currently active nix expression."
}

variable "s3_prefix" {
  type        = "string"
  default     = "asg"
  description = "The prefix under which Nix expressions and other configuration-specific state data will be stored. i.e., for the default value 'asg', expressions will be saved under asg/<config-id>/nixos/nixexprs.tar.xz"
}
